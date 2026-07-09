class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.143.zip"
  sha256 "b5381584cbc8591078b339ada159fb060586c0e1e4666b68b4a3958ef2e2b1e9"
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
    sha256 arm64_tahoe:   "d5b4d38605bdff6c2bd46cb28019931839146aaf6a4e58658faa033e3cc0032c"
    sha256 arm64_sequoia: "2da33eec774700d5c422b34eb5f83170ef2f4fadd0204819ff6e8973f3e0dc5d"
    sha256 arm64_sonoma:  "edf60daad375eda935b4a4af13f1c6953e6f784ba9a2f8f95fe191a3bc8db02b"
    sha256 sonoma:        "ed89c375bfc378b07fa2f5e9f8a334bf2809308fe6b6ea01dc8882fc43b5d727"
    sha256 arm64_linux:   "4e65287c72366aaaf6cbe81c31fd5d09328c74b8d19867182bf9eb82358d5707"
    sha256 x86_64_linux:  "1d22177a54f822327739bb1a5daae01d16c3a29a8a60fdb34c2521696e945c57"
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
