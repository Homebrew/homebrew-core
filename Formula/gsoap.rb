class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.117.zip"
  sha256 "7cadf8808cfd982629948fe09e4fa6cd18e23cafd40df0aaaff1b1f5b695c442"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "64a4384227bd706458260fcd39352c1065bed4458aafe88bee947cd79bc0d632"
    sha256 arm64_big_sur:  "fb074963567f15e35317ba190540835a9701746ba9a590002415ae6dc4083d96"
    sha256 monterey:       "2d615817bed23a54c53aee8b9efef6629f1b7980305d5e3580873db125968607"
    sha256 big_sur:        "84f24f86809047fdd972a9d192514b0d9ab08a27821ce07a3e60f33a44697459"
    sha256 catalina:       "6bee22cc8b7c43f3d41b51bd75c50cf0f444feed51d9bf5a4f7dd288d662a42d"
    sha256 mojave:         "d90706cf140e9b273d56007f6e56db0933686d50afae9a9703b862af3bce5b55"
    sha256 x86_64_linux:   "2ecb0911a0996e51f00d7e35a3729865bc19eeec3aaf5189ce54ee7e18c5d5a5"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
