class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook/"
  url "https://njw.name/getxbook/getxbook-1.2.tar.xz"
  sha256 "7a4b1636ecb6dace814b818d9ff6a68167799b81ac6fc4dca1485efd48cf1c46"
  license "ISC"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?getxbook[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b07982832dad4e00d9574247148c61ae88d8aab91130df3268589e129b71f74"
    sha256 cellar: :any,                 arm64_big_sur:  "dc9c26a35297ffa8f3b40051b6293104dfb3bc03cb2ceccf56d77e0b8e5d7b6f"
    sha256 cellar: :any,                 monterey:       "578a96921bab3c6c328b7ef2f99f88c333d2831cfe0f7166a1e7547974e60027"
    sha256 cellar: :any,                 big_sur:        "86d7a091869ff032ca24ddd7979ed545ca17775ad5c99fac92c706857c31eeb0"
    sha256 cellar: :any,                 catalina:       "a99745b1db4509b84e84c0306bdf4439086670e608e7ff7e4d89e5318547391b"
    sha256 cellar: :any,                 mojave:         "68f7f76c607807315d1e8305830eaa94d04e1c87f1ea1382fb00bd7ec74f2886"
    sha256 cellar: :any,                 high_sierra:    "dce13d6e7d9f5f0eb79064858dca9dc3d62b274ba1f07b2ceaca3bf06e4effed"
    sha256 cellar: :any,                 sierra:         "d4b7500ecfbcf0b0d4ff905b01589a546aa53da5c1c465878305c8b6ee2c363c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14dc92ce6828cfccce34307bfa2f750faf8612ef92f126797cd5b86e6fb5978b"
  end

  depends_on "openssl@1.1"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
