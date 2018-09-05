class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d9c3f473efd5d1a2edc928e12e12552cacbc40183042945b3bbef47532145e4" => :mojave
    sha256 "46a8499130fcdafc69e79436a77338398139b7ac54b3ae5f0ca9ba75b9f7efc9" => :high_sierra
    sha256 "4a29b90dc48e4ce505bb50e575cc91107df8d93a90fe49ab4ec02df6118158ec" => :sierra
    sha256 "55d89877bd5457b7a5b77cf68187f544ff413228ec17a701e7879644ae528f35" => :el_capitan
    sha256 "6269c8d291cea44aceda9bd8e1e93a061e64d76852e47b781ae49aee28f0c31c" => :yosemite
    sha256 "eb1a482e6da44ad722af99334618ddb17da926f4c88a8c85361e04ce0e59bb54" => :mavericks
    sha256 "04bc25b91630b8d7fb791529e9797d287db42f500af29db45314580a4b2591e5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
