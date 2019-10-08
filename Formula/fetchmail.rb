class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.1.tar.xz"
  sha256 "3f33f11dd08c3e8cc3e9d18eec686b1626d4818f4d5a72791507bbc4dce6a9a0"

  bottle do
    cellar :any
    sha256 "65f33f39bb4f3acb16f8fe1cce6c988c2aa28350923aea2aafa9db1631516e15" => :catalina
    sha256 "0d346ec2e1c1a4626846a5d2c9be1f21daa3aee32a7d5bc274ac060305ea9f31" => :mojave
    sha256 "12cd02292c26a27e9ef75c1fd8728412bb611df883962860d2db82b02a1679ee" => :high_sierra
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
