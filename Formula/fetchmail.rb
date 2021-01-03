class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.15.tar.xz"
  sha256 "735b217474937e13cfcdea2d42a346bf68487e0d61efebe4d0d9eddcb3a26b96"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "4558e666d1df4bd8c580b6fc0bca771868cdd22011590f136dcfc967d02b263d" => :big_sur
    sha256 "5d85bdc3e476f0903abec8336ab07ef0d19845d2d931f3689fc216eace648113" => :arm64_big_sur
    sha256 "b67dee738008d7bfec9676475bb0bded8cbe9224edc86356f240ebcc0051cac4" => :catalina
    sha256 "5ba114e574be07073607ee7788e60f7b75c5fd95f628b118e76b108689bd61d9" => :mojave
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
