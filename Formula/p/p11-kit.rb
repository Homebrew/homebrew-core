class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.9/p11-kit-0.25.9.tar.xz"
  sha256 "98a96f6602a70206f8073deb5e894b1c8efd76ef53c629ab88815d58273f2561"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "184383aa79a57f0bb18aef941c0ca6ce68dfcb19571337b0b09be2fe68589964"
    sha256 arm64_sequoia: "a31e4147c7072d39ee1e06f8fc2662366985d6688d6562dd0da8df6620c9d719"
    sha256 arm64_sonoma:  "5b63b2f4654579eadc51c0c58f72149f6d76913b2cb2f074515ff0835dc0a27f"
    sha256 sonoma:        "428b0ccda37b34b9516560d52d97bd9f2229aff5bd227ff7a4bc352fb7351752"
    sha256 arm64_linux:   "a39b9a8cdfb23f37530f255b5e41c384b02776394fd889562d8f38bf1954a96b"
    sha256 x86_64_linux:  "6a1620b7a97e86c05959c1087171808a2066d568f2e419449e7b8dc80fb1ce82"
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
