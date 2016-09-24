class Log4c < Formula
  desc "Logging Framework for C"
  homepage "http://log4c.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"

  head ":pserver:anonymous:@log4c.cvs.sourceforge.net:/cvsroot/log4c", :using => :cvs

  bottle do
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
