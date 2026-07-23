class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.github.io/p11-glue/p11-kit.html"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.26.4/p11-kit-0.26.4.tar.xz"
  sha256 "89c3ffb10e076ee036e14732bf6547a1e1c4fb48699a5dee7ceb5ce4f7c0c462"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/p11-glue/p11-kit.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "13dc3a504adf9c61cb31cd0b136c01a4b666adb39f6b8957c8ace466be33b334"
    sha256 arm64_sequoia: "1b427ea6b814392313cec01ea3077f9e9d1e0bf000c32483b5969b1ca5419cb4"
    sha256 arm64_sonoma:  "87061f6e7c61862172600ca4b094b0d2d09b5a06a3eac6da27547df322ccfe0b"
    sha256 sonoma:        "42cfc4ee22ce5f374e73ea3193aadb3cef03dc338cb2f14440029cc65bac05cb"
    sha256 arm64_linux:   "ba7bae2087f15176ab8dae4a615896926bf2bf5b7d8ca9f74a69585b5e0082bc"
    sha256 x86_64_linux:  "076f30fea99cb79412932a2e303ba0f39b43cb287632d5b3fa5b66dac7580a59"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem
      -Dsystemd=disabled
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "meson", "test", "-C", "_build", "--timeout-multiplier=2"
    system "meson", "install", "-C", "_build"

    # HACK: Work around p11-kit: couldn't load module: .../lib/pkcs11/p11-kit-trust.so
    # Issue ref: https://github.com/p11-glue/p11-kit/issues/612
    (lib/"pkcs11").install_symlink "p11-kit-trust.dylib" => "p11-kit-trust.so" if OS.mac?
  end

  test do
    assert_match "library-manufacturer: PKCS#11 Kit", shell_output("#{bin}/p11-kit list-modules --verbose")
  end
end
