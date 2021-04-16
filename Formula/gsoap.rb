class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.112.zip"
  sha256 "05345312e0bb4d81c98ae63b97cff9eb097f38dafe09356189f9d8e235c54095"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_big_sur: "7891eb20b56cb5a7bacf65ccdbf059488e22e4b2b15ebfe0f0d355256a306a8c"
    sha256 big_sur:       "a814c1dcd0c152d3ddbabfb97f2154988d4591cb21692c7cd6f2a6e1c3eb0344"
    sha256 catalina:      "08451913b3b7a6c78c08e2a19c8dcc604b8bf7b91b73d8fc35aaffd8a29f94c7"
    sha256 mojave:        "2de9e6ab9bd260b1a9423fa7e390dc2a3334ec7f94227fdc4fa350b4a91e9efe"
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
