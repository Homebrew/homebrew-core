class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.141.zip"
  sha256 "bc8210e97a81a659a18c748e998958ae369d35fc5f6ba3a097b42780fedd5a59"
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
    sha256 arm64_tahoe:   "a0967a0c4cc80867fc181d277679a8107a67b6fef18835888022d27f0b6d1c8b"
    sha256 arm64_sequoia: "930562555fd62f6df5f052852a19862ebd69145e343b874a504aad30a6ea532f"
    sha256 arm64_sonoma:  "936268674361346c3a1b3f10e05a0defedb76a4480fa4b576c319e30e72fb4de"
    sha256 sonoma:        "a61e8e82f481d9be8ffbc84346d068683ba32aa83e704393d43560446224b9af"
    sha256 arm64_linux:   "276d44019e1b2b5e8d19e7c6db7191627d9ece9b72b2069677fe83a7c5fafdfc"
    sha256 x86_64_linux:  "dfd0ce24749e59232d2d636750e4686636326ced713316276e2b8d405ea47c41"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_path_exists testpath/"calc.add.req.xml"
  end
end
