class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.139.zip"
  sha256 "74d1d7854c8ff500729a3003fd07536e417f3e900aee2eeb2d9300d70e4c047b"
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
    sha256 arm64_tahoe:   "72229c99d5d7dbf013a811ec2c9fe683518a1b3272eb10c76a7ad1ca4551f738"
    sha256 arm64_sequoia: "958e8c5f5456b2e239a6588f20f0556b65b34ab9eb0a71bcb14d0ab256a13cd4"
    sha256 arm64_sonoma:  "c07f6a68b10e0b23460eabc0e8218184580d51803bcce11e3ea74f0f798a89a3"
    sha256 arm64_ventura: "7442597995fd7bc974354f4b380ff2cadbed08e1310805af93d11abdcb292cc0"
    sha256 sonoma:        "31a88d301a49265882f616da77291e262c73af2867e1769c2829307295c0a01c"
    sha256 ventura:       "54c940a55fa1dbaa56df1dd028faf0648043adf95005f3a5f7d62e76fd3a1744"
    sha256 arm64_linux:   "553af9c6cfedc702985ec82cf5807dd175c1a97678484231ab10748a0af781c8"
    sha256 x86_64_linux:  "1a7db005a648b50e584704b2b53783ce0718b74ca06e60b6d9996a9546cbba9e"
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
    assert_path_exists testpath/"calc.add.req.xml"
  end
end
