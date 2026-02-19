class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.github.io/p11-glue/p11-kit.html"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.26.2/p11-kit-0.26.2.tar.xz"
  sha256 "09fd9f44da4813a3141e73d5e7cf7008e5660d0405f13d56c15e1da9dcecf828"
  license "BSD-3-Clause"
  head "https://github.com/p11-glue/p11-kit.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c814d01363bc8e35892432f19074e507d16b1bce3f88635478969050250079ba"
    sha256 arm64_sequoia: "62a02e67a42d05aceb5653bd5d4be971172484fa9def96f066963a6fb4ca3f11"
    sha256 arm64_sonoma:  "bee65fbab57c03c46620379593e7bc4865cce0bf2db794cf22bdfcc1eb564979"
    sha256 sonoma:        "e1e808da48ab0eb63ff145b55a3407d0265501e09b4e627f8ba02ecc654c3663"
    sha256 arm64_linux:   "1924836b8e56a59363d2e294f1c2ee40b62e1b4ffd6600e7c0de78d11b90fbbb"
    sha256 x86_64_linux:  "52d46084406325d13f58712ee3afbec2f78eb7cab0b57acda36597b607800d85"
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
