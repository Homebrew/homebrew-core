class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook"
  url "https://njw.name/getxbook/getxbook-1.2.tar.xz"
  sha256 "7a4b1636ecb6dace814b818d9ff6a68167799b81ac6fc4dca1485efd48cf1c46"

  bottle do
    cellar :any
    sha256 "a7974d5b7253344ac329a998de5a06d4c0c8908a0951067d9b735582c43bd570" => :mojave
    sha256 "fe6eb0a45995aafd518535671a6c7e17e3a8611e2c5444d0a420045d23e8006b" => :high_sierra
    sha256 "16cdf74891b198e58f17345425ad29bc678c0164acb223872a618f0929a934f0" => :sierra
    sha256 "36c96e48b025d7b483dab3d9bc7283d677885e1db23ad5c3c8947e49c34ccdb5" => :el_capitan
    sha256 "b0b609d26eb1faeba89e929f6f6099297d14957d22653720adb61fbed9e492da" => :yosemite
    sha256 "00f0f25a3d3440b0c7f98b2881c0750c9e568cfa685de2f89dbc43f58e667fce" => :mavericks
    sha256 "74b03216052c58cfe830e69c169342ae6eba9fb24a92b25f3fa3794a015564d2" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
