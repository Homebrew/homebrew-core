class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.8/p11-kit-0.25.8.tar.xz"
  sha256 "2fd4073ee2a47edafaae2c8affa2bcca64e0697f8881f68f580801ef43cab0ce"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "ef581d3e882b5a63bb27ffb0551b17e0ca30b8c0683ba4cfd4d9742079342f01"
    sha256 arm64_sequoia: "4b4c6317a0f8d86da5d28f5d007e09261c399495702de85740f94434ca444ba6"
    sha256 arm64_sonoma:  "fd33d5a316258e8ffef0e516431364dee2d3971becf35d089a817eb124a929d3"
    sha256 sonoma:        "1c2e8ea6929035249d454facf9e2030c3ee9e7ad56b2b3fc1eb11de6998981a2"
    sha256 arm64_linux:   "87dfc23bc554d901ff0bae3172d8d6cbd88c6a5385fe760df094f5d995100031"
    sha256 x86_64_linux:  "c7e65a8168c796f263301a7ad748eebd1ead9db09cf16d669912c7000a98ed8a"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi", since: :catalina

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
