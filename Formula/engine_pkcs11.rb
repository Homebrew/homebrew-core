class EnginePkcs11 < Formula
  desc "Implementation of OpenSSL engine interface"
  homepage "https://github.com/OpenSC/OpenSC/wiki/OpenSSL-engine-for-PKCS%2311-modules"
  url "https://downloads.sourceforge.net/project/opensc/engine_pkcs11/engine_pkcs11-0.1.8.tar.gz"
  sha256 "de7d7e41e7c42deef40c53e10ccc3f88d2c036d6656ecee7e82e8be07b06a2e5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "56eaaffee53413b6e08cd6827773d45384cfa6de5cc9ef850bee99f93a9d42a2" => :mojave
    sha256 "4470e2808bbb7da8f3f1a16d8567d335b9bf1b5e2554608df3670a73b26a67af" => :high_sierra
    sha256 "072026206d634b15d76a5784358116b159aeadd9208ceac8e927d2fbb9b29bcf" => :sierra
  end

  head do
    url "https://github.com/OpenSC/engine_pkcs11.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libp11"
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
