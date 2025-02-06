class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.136.zip"
  sha256 "64de6af1f6019810d91ca1497815fdff576e38dc2d9c7e3d3e9e1cbb443aeac3"
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
    sha256 arm64_sequoia: "e141146e4dde4ec85425c009613ea6d4113f69116941c1644551937203908e12"
    sha256 arm64_sonoma:  "1bd2749d1a45958623553d81a2ba4ffb11027988bdde53a0b130d7a265ad844c"
    sha256 arm64_ventura: "210572f3470466558641946d65b6ae878bdf6e979ae724cc0c252a4f253f8617"
    sha256 sonoma:        "0f3772e1468526e2bb3c0395b90531c6002bd91dd71cee4537960d088d73e073"
    sha256 ventura:       "acc3f9cae0518acbf9d21791c21016af2c5342ce408f985768e93246904d9f92"
    sha256 x86_64_linux:  "d3a52a178e3e1ae413c25e89d9d384b806c24d0c49fd15764c64887ed19c41a1"
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
