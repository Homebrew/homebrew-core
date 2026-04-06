class Build2 < Formula
  desc "C/C++ Build Toolchain"
  homepage "https://build2.org"
  url "https://download.build2.org/queue/0.18.0/build2-toolchain-0.18.0.tar.xz"
  sha256 "392b8ac4e491b02ade4348fa597e8ca0d0e300f352a9736886648a6f1052a2a7"
  license "MIT"

  livecheck do
    url "https://download.build2.org/queue/toolchain.sha256"
    regex(/^# (\d+\.\d+\.\d+)(?:\+\d+)?$/i)
  end

  bottle do
    sha256 arm64_tahoe:    "04b1c4088629832bebbfd1b82b8132b14ac4d623585dc9a3d2e3147be53025e6"
    sha256 arm64_sequoia:  "70ffd3523f4b4d74bd22b1374963bbefc8308140252481c2fd97972360757619"
    sha256 arm64_sonoma:   "0e7160137ee4ed4148b5b7219224029a1120d0429425602711d3a175f743bcb2"
    sha256 arm64_ventura:  "8f144b91ef3c6cece42e79cfac3422f0c7c88291f0e5cd3cc8d93b7eaac09936"
    sha256 arm64_monterey: "56b872f3baf6900a98dbed0703dd9ea2e6aad437c9ae54b1aac417ec7d1be475"
    sha256 sonoma:         "b7ac1377358cb2440b33094f30e696cdbf4b7e77f90f126a220f223299fcaf6c"
    sha256 ventura:        "e7e1b9212dd13e228cba7aa96cff10688da90517bad8806fa65e55170ef67e1d"
    sha256 monterey:       "2e9e1e8bf14f7daea54d814e7919353b52fd257d82394c6dccbc258f18b59c8c"
    sha256 arm64_linux:    "8aff877f3d60ee2c1260951e873f9aa3790073643aaae93a87004e45e349d2b0"
    sha256 x86_64_linux:   "b0bf7ddb8cc3cb9a9d196d86bc76bba253460c31b55e7914acb8d1d72d2a297a"
  end

  uses_from_macos "curl"
  uses_from_macos "openssl"

  def install
    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"

    # Disable the fetch cache since it doesn't buy us much. Moreover, not
    # doing so may mess up the user's cache by migrating its database schema
    # before the toolchain is even installed.
    #
    # Note that while we currently don't run bpkg during installation, let's
    # keep this in case we ever do that.
    ENV["BPKG_FETCH_CACHE"] = "0"

    # Note that we disable all warnings since we cannot do anything more
    # granular during bootstrap stage 1.
    chdir "build2" do
      system "make", "-f", "./bootstrap.gmake", "CXXFLAGS=-w"
    end

    chdir "build2" do
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

    assert_match "build2 #{version}", shell_output("#{bin}/b --version")

    # @@ Change to "bx #{version}" when `bx --version` is fixed.
    assert_match "build2 #{version}", shell_output("#{bin}/bx --version")

    assert_match "bpkg #{version}", shell_output("#{bin}/bpkg --version")
    assert_match "bdep #{version}", shell_output("#{bin}/bdep --version")

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
