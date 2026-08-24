class Build2 < Formula
  desc "C/C++ Build Toolchain"
  homepage "https://build2.org"
  url "https://download.build2.org/0.18.1/build2-toolchain-0.18.1.tar.xz"
  sha256 "a5f3eab9d4522bc22704899593dd6c7013349a1b8c37278c8b2321073e25ff16"
  license "MIT"

  livecheck do
    url "https://download.build2.org/toolchain.sha256"
    regex(/^# (\d+\.\d+\.\d+)(?:\+\d+)?$/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "5285330bcb3d10f853f55dd47d0c37cc7aa13ccf118cdab916c558d7cdb757f7"
    sha256 arm64_sequoia: "16688040662f95704dae80d2242f0fcbc9f9ce2fa8723f01afeb71e13c7f4368"
    sha256 arm64_sonoma:  "481e0ea6a362b715cd43f21465940b295a343a094160f861abec2843aac31c47"
    sha256 sonoma:        "890a45940a76257dff905329017e4b40649bb462208196bf3e815ea21fd59c80"
    sha256 arm64_linux:   "c2a9bdf5aadeabcd3f52bfc1ca86d3ae84db50753c2f75b4808ed60eb5746b52"
    sha256 x86_64_linux:  "2e3575fab6e893e8558be4890a85b2fad46ff1ffa9a26e967bf2f2553e4d24c4"
  end

  uses_from_macos "curl"
  uses_from_macos "openssl"

  def install
    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"

    # Disable the fetch cache since it doesn't buy us much. Moreover, not
    # doing so may mess up the user's cache by migrating its database schema
    # before the toolchain is even installed. Note that while we currently
    # don't run bpkg during installation, let's keep this in case we ever run
    # it.
    ENV["BPKG_FETCH_CACHE"] = "0"

    # Note that we disable all warnings since we cannot do anything more
    # granular during bootstrap stage 1.
    chdir "build2" do
      system "make", "-f", "./bootstrap.gmake", "CXXFLAGS=-w"

      system "b/b-boot", "-v",
             "-j", ENV.make_jobs,
             "config.build2_toolchain.build.readonly=true",
             "config.cxx=#{ENV.cxx}",
             "config.bin.lib=static",
             "b/exe{b}"
      mv "b/b", "b/b-boot"
    end

    # Note that while Homebrew's clang wrapper will strip any optimization
    # options, we still want to pass them since they will also be included
    # into the ~host and ~build2 configurations that will be used to build
    # build-time dependencies and build system modules, respectively, when
    # the user uses actual clang.
    system "build2/b/b-boot", "-V",
           "config.build2_toolchain.build.readonly=true",
           "config.cxx=#{ENV.cxx}",
           "config.cc.coptions=-O3",
           "config.bin.lib=shared",
           "config.bin.rpath='#{rpath}'",
           "config.install.root=#{prefix}",
           "configure"

    system "build2/b/b-boot", "-v",
           "-j", ENV.make_jobs,
           "install:", "build2/", "bpkg/", "bdep/"

    ENV.prepend_path "PATH", bin

    system "b", "-v",
           "-j", ENV.make_jobs,
           "install:", *Dir["libbuild2-*/"]
  end

  test do
    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"
    ENV["BPKG_DEF_OPT"] = "0"
    ENV["BDEP_DEF_OPT"] = "0"

    # Disable the fetch cache.
    ENV["BPKG_FETCH_CACHE"] = "0"

    # Only match the major and minor version numbers since the patch number
    # may differ. For that, convert the version string to the
    # '<major>\.<minor>\.\d+' regular expression.
    vre = version.to_s.sub(/^(\d+)\.(\d+)\.\d+$/, '\1\.\2\.\d+')

    assert_match(/^build2 #{vre}$/, shell_output("#{bin}/b --version"))
    assert_match(/^build2 #{vre}$/, shell_output("#{bin}/bx --version"))
    assert_match(/^bpkg #{vre}$/, shell_output("#{bin}/bpkg --version"))
    assert_match(/^bdep #{vre}$/, shell_output("#{bin}/bdep --version"))

    system bin/"bdep", "new", "--type=lib,no-version", "--lang=c++", "libhello"
    (testpath/"libhello/build/root.build").append_lines("using autoconf")
    chdir "libhello" do
      assert_match "project: libhello", shell_output("#{bin}/b info")
      system bin/"bdep", "init", "--config-create", "@default", "cc"
      system bin/"b", "test"
      system bin/"b", "-V", "noop:", "libhello/" # Show configuration report.
    end
  end
end
