class Log4c < Formula
  desc "Logging Framework for C"
  homepage "https://log4c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"
  head "https://git.code.sf.net/p/log4c/log4c.git"

  bottle do
    sha256 "8e35c261de43e25fe934f9f77875ff9c5fa6bdc4297fd0dd2fc657a5acd680ae" => :mojave
    sha256 "4019efd84d56e2390feff696e1fa3305b788fdcb3105c5b6117913e81a16a7f2" => :high_sierra
    sha256 "171a6c3f12f957d5442998f0f02df959aa4376ef543338765930ed4e062ef0ea" => :sierra
    sha256 "2334e58e3ae201b28362707d2b64701e2e1378695e915baad886956e4edea50a" => :el_capitan
    sha256 "d345d0ab182855859fb21148c708893a395ecd416ba3f05d5e2a5a3111f2bc61" => :yosemite
    sha256 "676eeaaf8bb2b112ff1e5c1586cc0302e6e5dd0253939b7533dd519095497171" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
