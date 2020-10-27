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
    sha256 "ddfe9fb2f887e126a342d328f15e1e605dc4e3a010de8ecd2f8c87c6ec9f41c6" => :catalina
    sha256 "acf99e4e026b233c26d45d0b6eb902aaf2fd94fef8ad88681dabb14531bd9391" => :mojave
    sha256 "c934824791e311a5a18f442a41822338d6a1ef5446d4bc52bbf9b7319991a1b2" => :high_sierra
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
