class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.2.tar.xz"
  sha256 "e21f6b3326f29fdb0c4786b5602aa4b9e668805424d0708eb42be6395c1ca630"

  bottle do
    cellar :any
    sha256 "d6aa8d08a376a6a2c0014a6ca32b092a4df9f5f2cda74cbe959ec38723671ccf" => :catalina
    sha256 "98f637af26d26b71e9782192be0a472d35ce906e4036a8bba0e4bb9e73278f3b" => :mojave
    sha256 "938aab5140a651e8ecc973a96d465f4f0974c8597890a648cc856ea9da37bb7f" => :high_sierra
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
