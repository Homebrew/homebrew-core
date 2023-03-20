class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.126.zip"
  sha256 "b65190ebf8c2517d6fafbdc2000bc7bc650d921a02f4aa53eb1e3df267592c4a"
  # Parts of the software are alternatively licensed under gSOAP-1.3b, but this
  # license is considered non-free by Debian and Fedora due to section 3.2:
  #
  # 3.2. Availability of Source Code.
  # Any Modification created by You will be provided to the Initial Developer in
  # Source Code form and are subject to the terms of the License.
  #
  # Ref: https://salsa.debian.org/ellert/gsoap/-/blob/master/debian/copyright#L7-26
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_ventura:  "75ba4bece1b59d16aebf5fa42950158dabdafafce8d0de3d4b87e2de41a49222"
    sha256 arm64_monterey: "7423619c7c6a1667f846bf54e9b76fc67599a7b31170a9d8ce159b158f6268c4"
    sha256 arm64_big_sur:  "7187fa8d27126cf09e676eab83e7a47f8bb42b13e2bf5ee0b10d5f200d57a6e3"
    sha256 ventura:        "aa8a178b74904941a5ed7e056f338cd37cc86716e444394fb59394846b2229b1"
    sha256 monterey:       "e21df235edb8e72a214a2e48b6a0b5a9b2b13c3a0258b7fcfecf7ab1e977b16b"
    sha256 big_sur:        "2c776cc46f7477ed1aa766d0031ec88a4daa73618a5bd0dafe073dcc1cb73ba2"
    sha256 x86_64_linux:   "fa417740da818235f2fd7817b6c7f7690c8ae1b9195830dde277c94f7a1c0975"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
