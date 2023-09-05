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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7254e0b761a6e9eb9388b1a7af5f70d4ec26afbfec79924a11ff343ac68cffd8"
    sha256 cellar: :any,                 arm64_monterey: "2237deb414c3adb1808dd399db44aaa9716d6c015a23091fd0293551caa18d41"
    sha256 cellar: :any,                 arm64_big_sur:  "00932264ebc086317cc3ef8fbd68c7cc06be424ecd51c331fc84797a1a862268"
    sha256 cellar: :any,                 ventura:        "cf59d18cfd93e5378cfa7d99833955936c352c78de14f30fea628fb828057bb0"
    sha256 cellar: :any,                 monterey:       "95ba1369c672fc85ee368dfeed1854d0c60ead37fb2ee61d970b62e4c0ae5668"
    sha256 cellar: :any,                 big_sur:        "2af17bd072313e56ca6c199dcf9aadbdfbed69288fb21345a7395777b5d88a45"
    sha256 cellar: :any,                 catalina:       "431582f1011ac367afc22623e6a5fdf3dfa8839999c69212ce32e986948c3c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c87c43136c6d85bd87766fff817a618abedc7392a1a4be393acd0546a02cdc6"
  end

  depends_on "openssl@3"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
