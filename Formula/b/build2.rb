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
    sha256 arm64_tahoe:   "cb8cbd44ac961e64fc6f3de1fb9f6ac6c9bf8b463ed054155e9a8dbedc85eb28"
    sha256 arm64_sequoia: "1b4984cb8e3354f11453950e150950ddb6565961e21656d7c47ab827e1bffa74"
    sha256 arm64_sonoma:  "60b08680cd40ac0906aa137deb4e99a382b898bde5648dac762825cd91206d1b"
    sha256 sonoma:        "eec49c98a98fdc2f5a8b01f20281bc03242dc4c8e527a5c572bc89373e7ebf27"
    sha256 arm64_linux:   "712bff9e7552e0c0c7e81278a9563cb33720bb3635da5c23e2a31e589ba0ffbf"
    sha256 x86_64_linux:  "785d9ca27bc1c86c889dae9680beeed9261e9f6affd4dad7ee446d0d13e87283"
  end

  uses_from_macos "curl"
  uses_from_macos "openssl"

  def install
    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"

    # Note that we disable all warnings since we cannot do anything more
    # granular during bootstrap stage 1.
    chdir "build2" do
      system "make", "-f", "./bootstrap.gmake", "CXXFLAGS=-w"

      system "b/b-boot", "-v",
             "-j", ENV.make_jobs,
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

    # Only check build2 version as eg bpkg or bdep may not have the same version (intended)
    assert_match "build2 #{version}", shell_output("#{bin}/b --version")
    assert_match "build2 #{version}", shell_output("#{bin}/bx --version")

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
