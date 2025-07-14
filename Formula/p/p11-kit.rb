class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz"
  sha256 "04d0a86450cdb1be018f26af6699857171a188ac6d5b8c90786a60854e1198e5"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "396f31b164e77e386922d5a8ceeeb2860d2a8e27b5ffc43e2444e49842d47055"
    sha256 arm64_sonoma:  "71c1869311d18d9ecca257c474c6b33eaee4a8980f10eb6987486234112f9f46"
    sha256 arm64_ventura: "e3bc89565cdd9876efd50024e24b5ba4c3ef5aa62b99f69b65d92fd47d24c0d9"
    sha256 sonoma:        "25ad80618527fcce7e347062f9670c3b47df5682b9b9c0b29fb16a67566a68bc"
    sha256 ventura:       "5b2ac57b324eca4c1d700ecdc079f5add6f8d0175590e9f45fe8e222fade0689"
    sha256 arm64_linux:   "2b1c5ab7f1203d42bf9f9fda701cd49b709cd4fddbfe4cee4b87bcac0f6ad336"
    sha256 x86_64_linux:  "2edb52c3990c1552a5fe19d8e25e6e89300b1f07d5e6164d3ff2a2591e83894d"
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
