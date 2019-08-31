class EnginePkcs11 < Formula
  desc "Implementation of OpenSSL engine interface"
  homepage "https://github.com/OpenSC/OpenSC/wiki/OpenSSL-engine-for-PKCS%2311-modules"
  url "https://downloads.sourceforge.net/project/opensc/engine_pkcs11/engine_pkcs11-0.1.8.tar.gz"
  sha256 "de7d7e41e7c42deef40c53e10ccc3f88d2c036d6656ecee7e82e8be07b06a2e5"

  bottle do
    cellar :any
    sha256 "ab9088639272a437ed4e2e4bbbd017f7ac2a3e9e010e23255afcbd0ac90c9005" => :mojave
    sha256 "d6aae033f4a43482334c5446b0dc5b21d04492135f8a73bdf10318696667867c" => :high_sierra
    sha256 "8fc6fe2cf14c79223c4930c825e4b42435fe87a6c20b87a1e03ad13702eb3d55" => :sierra
    sha256 "cd24061981fd0cd78e5c82d92c0ef686e2c8eea8a54e49339bf0606b51566b12" => :el_capitan
    sha256 "af4873db45f9cec2e7dec281f646addeaac288a6ddf349fd731a8ea2e5809957" => :yosemite
    sha256 "c8fda4c457231986703ffae42ef0033eb6afd05ed891d7b7ede2c38f14dd1105" => :mavericks
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
