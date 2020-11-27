class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.14.tar.xz"
  sha256 "424707390f7cdc6d16db4887931117f2242873846b28cc1d0ae1c0ecf158bdcb"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "fd22ee8f06b1b13f8e8e2ffbae80f46d265db5bf8d4ac5e32520e9b3442f5d90" => :big_sur
    sha256 "4d8de02963568efa7ee1d6981ba07a65a3a71dae716b6c39d50194041412b654" => :catalina
    sha256 "ec6784b3cfb19a9b71b5ad52b9a27d35cef4f059ca8bf0a00ae2efe824450de3" => :mojave
    sha256 "6c6899e760722945cf40667a1e6300180c5623da67cb024d21242cfd1e9c2543" => :high_sierra
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
