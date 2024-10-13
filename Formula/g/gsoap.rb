class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.135.zip"
  sha256 "b11757e405d55d4674dfbf88c4fa6d7e24155cf64ed8ed578ccad2f2b555e98d"
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
    sha256 arm64_sequoia:  "63cfd0fe9a94907975213a9272919131e33ce2faaf1c4872c2557221fde118c2"
    sha256 arm64_sonoma:   "b60301b1d6f420406092b734929f40efddb4668d1c51d3fb9d3fa5f3703e3737"
    sha256 arm64_ventura:  "bb05a9f9c36288ad8e2c5d09316c8a0e3ca6d5575655f74f814f128c15fa4b3a"
    sha256 arm64_monterey: "68302fa08d48563abfefe24dcc8b54f7986a4ad01376e8a4b6b1cff88d49b9ab"
    sha256 sonoma:         "b5bfdfe1ec6cd41ed8ac76bcea9574466849a394fc2c90a597142fa88de2e082"
    sha256 ventura:        "d9abc23ff99e1436efe95ecd454cbce0a917591b08dada57438c4acc0ec41928"
    sha256 monterey:       "c125b81fb7c4b80c6e57eec8e1cf4ce2654d0cd9bfa9a96b8df4a38994531aed"
    sha256 x86_64_linux:   "fd6dc62a1491f7156bc0cf929886c696e4d5f918c30f72e203afb1e9b1ccf985"
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
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
