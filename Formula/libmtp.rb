class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.19/libmtp-1.1.19.tar.gz"
  sha256 "deb4af6f63f5e71215cfa7fb961795262920b4ec6cb4b627f55b30b18aa33228"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8dfa1790c2dc78ab35215490a1beadad0119cc016304e12e6fb9fa349f2fc11"
    sha256 cellar: :any,                 arm64_big_sur:  "0d8204a3be05bd4e9d81b0fcfeb8c188d42905749f5b5a810f176e57ee6bc2c2"
    sha256 cellar: :any,                 monterey:       "35640d39423cb68b9bc63daaf79bbe50c45d5e48135d4a727b56198b25ff2f91"
    sha256 cellar: :any,                 big_sur:        "fe872960e99114fbd0d4be480a15ec26fdc026aad3ed4da3f3e2fd15abb15ae8"
    sha256 cellar: :any,                 catalina:       "f12d61d228ec4e1441c8d8f12dead6c3bebc7123485dbeae515a691c288587b4"
    sha256 cellar: :any,                 mojave:         "09489dbbe7941577ecccf2db5950e9ffb6f72b3caf85f6a4de08affae30f7e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c0d3a716b3557bcb1e6d839e05b39f8160a22e1e2761476a57ed88d8a64959"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz",
                          "--with-udev=#{lib}/udev"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
