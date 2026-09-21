class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.github.io/p11-glue/p11-kit.html"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.26.5/p11-kit-0.26.5.tar.xz"
  sha256 "f2cc09111e44bf3fea58f023180b33acea90aa82d042d6fbb623fbc5ba033bb7"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/p11-glue/p11-kit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a7c4679040141c7c8cb0861e164126871f7e0eb485df6da5ebecc3665e185ce2"
    sha256 arm64_tahoe:       "fd108a936783ac40b4c3ea4dda639e7d22faa063e9f40f92b0ed2b2a7e99efa6"
    sha256 arm64_sequoia:     "6a61302c1be785c331903fe9252f87d0d4ca722fda0697c4e22f6063cd4f1be2"
    sha256 arm64_linux:       "ddcba9bb43653115779bb59a0ffa39b54b38342fba6791c84211fc205df0918f"
    sha256 x86_64_linux:      "4e8df948a2da3c78610d58f669b8dde39f2ef8ed879579cc7c338c44980209c6"
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
