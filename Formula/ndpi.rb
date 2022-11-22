class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/4.2.tar.gz"
  sha256 "e54ce8fe13adc5d747be7553513657fae78f796e0bd459e122c280cc06ce4daf"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "007d9adcffe3bf64b40d223d123ad80d063260901e000c42207d95a5de62e3ef"
    sha256 cellar: :any,                 arm64_monterey: "67f203560cd7389e2eeefcaf4333d1c2c177184c363fd049d38c954e28f54151"
    sha256 cellar: :any,                 arm64_big_sur:  "65f77fdd73e981b20f3bb393533d2b721cce0842cf1ce3874a651d95eeca571f"
    sha256 cellar: :any,                 ventura:        "51ead3433c90fcd5d6a5f677f6ff418d949ce9f4a65b40a6dfe64929d8cebf91"
    sha256 cellar: :any,                 monterey:       "0a194f0a5086f827e76947b695dd06908ecc0d08b4066e1cfc2d291592b7c76c"
    sha256 cellar: :any,                 big_sur:        "6d492a1b34e348a6d39711c406b7c582b17bcdfe3c056a58fafe63904b1543de"
    sha256 cellar: :any,                 catalina:       "ab97d26b5b5b8beeed6a8d9157c21d8d29a0d36776c1ba73017cbc37e3286ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e388612f8fec3e9e5f8135845dbde90671fa67e9b9fd75613c11a1111da640e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
