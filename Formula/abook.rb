class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/abook/abook/0.5.6/abook-0.5.6.tar.gz"
  sha256 "0646f6311a94ad3341812a4de12a5a940a7a44d5cb6e9da5b0930aae9f44756e"
  revision 2
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    sha256 "aa37eab8b488f96dd3d54236309ed7841aaeede27a179b4de7415fb8711dc904" => :mojave
    sha256 "3eb9e2e7003ef3501c63d87a5a632791769c84ac4d81a2c5fe1d40c04986e19f" => :high_sierra
    sha256 "e32cff277928e0b5cd24f201b1b5f94faf5469f263856b48c78f85b539018c86" => :sierra
    sha256 "fc5e09a73519a20dbe90258d6779bfddb1a02b2fc277fd54b4cd8c80c378539d" => :el_capitan
    sha256 "2f3a8d37fd17ecdda801f8de53e4048f19d824748e11a34c6f9abca0aae06c3b" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end
