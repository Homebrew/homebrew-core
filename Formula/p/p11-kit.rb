class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.github.io/p11-glue/p11-kit.html"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.26.6/p11-kit-0.26.6.tar.xz"
  sha256 "5fda95dc89964af32dbd8e01b139c166717cf96c4fee3d601bcd60bdb23d23c6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/p11-glue/p11-kit.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "a0751e0579ea06c14793f5b95093c34921df22e74cfe9101d0d396e44b7d378c"
    sha256 arm64_tahoe:       "9ed312a272c9972e1122b0957e63e944d2875d38bec6c865cc9248114487d2cc"
    sha256 arm64_sequoia:     "5d529f086a87a2d2e6dc22b48e43502943cbd900bc2e3350a32b1337078eabb2"
    sha256 arm64_linux:       "7f0e904b2199b43ee0734afac6c137a3a65a93a5d50b8716f7129e279433281b"
    sha256 x86_64_linux:      "2c308eee58e480734ec818cc86f8634cded3b81a7d3d539acf07ff322f29617a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi"

  # meson test runs a server so needs network access
  allow_network_access! :build

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
