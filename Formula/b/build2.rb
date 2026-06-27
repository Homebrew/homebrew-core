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
    rebuild 1
    sha256 arm64_tahoe:   "318a377c119ecca557ef895ae07e61021fa6cb9fffb4f47014b57f53d9f60113"
    sha256 arm64_sequoia: "a14c1755ea6530c51b49dfea2f86fba00854bf94d8b007796381c855a46b91c3"
    sha256 arm64_sonoma:  "21522e80e889e0f15629a64c782f56e3bead0f69c329d76c2790b9914046e7d8"
    sha256 sonoma:        "a4f666f74b07e71c7ef0372ef26e607795928b898ddd69e2be43b6cb310fbbd5"
    sha256 arm64_linux:   "4bc5456989c41445ed9ffb8b522bc1a1c27b73b0e8a73f04240960ac9ce46582"
    sha256 x86_64_linux:  "8283d89a3b27cb076b04a665da215d126ff068be6673ee1330a5cba4a80aa78b"
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
