class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.12.tar.xz"
  sha256 "2b84e0971dbf683ec7edd313f9218adbc7dc51c1de9825b3b549bf619c1a4887"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "aca86c45b01efbcc9e9260d92964cf7e065cc631fe9625d08741a13c561f9b22" => :catalina
    sha256 "26842345fb10e4671452000df49757eb7f9285126732119141bef5512e5780a8" => :mojave
    sha256 "7ac776850d7a53127caae85ad69bebac308304cc9b146efc901c35c3db9bae73" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
