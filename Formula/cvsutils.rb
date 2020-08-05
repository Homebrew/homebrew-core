class Cvsutils < Formula
  desc "CVS utilities for use in working directories"
  homepage "https://www.red-bean.com/cvsutils/"
  url "https://www.red-bean.com/cvsutils/releases/cvsutils-0.2.6.tar.gz"
  sha256 "174bb632c4ed812a57225a73ecab5293fcbab0368c454d113bf3c039722695bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8637db7bc660a9953b96bca2e68d1ba7c56bd0766e0ef12bc6b0b42d972ae3a" => :catalina
    sha256 "e497ac1ba036fec1ccd8d34b2ec6262f9721ab805d0636f073c5406ef4fbd922" => :mojave
    sha256 "102456ac28b63271b03a5722e8421d6273005c54203f4f818678be065479463b" => :high_sierra
    sha256 "d1f2e13e0df6dbb767a04f7e206114c119f9e6435f227e07e14b4d200e6aba8f" => :sierra
    sha256 "f8e35c8b0ed2db868e7dd12f653c20d7d2709059fb5a773fd49084a2655f4ca0" => :el_capitan
    sha256 "ccefce4b4a1053e9a32e4f43318c7bf73c7154f0bee1be1cf1777e8fd3e8eabf" => :yosemite
    sha256 "ab6140058099bdc798e0e294640504035d5c976a8752742044a161c416e2e31e" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cvsu", "--help"
  end
end
