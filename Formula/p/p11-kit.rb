class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.26.1/p11-kit-0.26.1.tar.xz"
  sha256 "4769f81483a28040cce1dac09a99599f787a8e0dc239a3089d4b0f676b7c4561"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "db42938d5a3e965a3aa32fc188dd5ed7a4d3f95ad6564d93571aaf466b43d00e"
    sha256 arm64_sequoia: "affc5764d8a7ce86b59040abdabd6b855dee5b8ad012cb667de318a98f386af9"
    sha256 arm64_sonoma:  "15171bed1420e294c30b36588984ffac21471b976bc0d485b39dbc3e81009c77"
    sha256 sonoma:        "56f882ac1e877a783c8245ceddcb94e05bdd5a076262c490c4bbfbf65db0a54c"
    sha256 arm64_linux:   "3cf3108ec3771b4eef4efd034d20e45c151dfb8e81b62872e7bc4ced9f5c1a1a"
    sha256 x86_64_linux:  "a5f1d41ab76ede2673952fd7222d76fa29881e75513887133d69c7b75d09f2d6"
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
