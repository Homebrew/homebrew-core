class Herrie < Formula
  desc "Minimalistic audio player built upon Ncurses"
  homepage "http://herrie.info/"
  url "http://herrie.info/distfiles/herrie-2.2.tar.bz2"
  sha256 "142341072920f86b6eb570b8f13bf5fd87c06cf801543dc7d1a819e39eb9fb2b"

  bottle do
    sha256 "5d6d73767063b7f2be104fd2dbb00d8bf3b561a06e9720a822f60972bfb70d79" => :sierra
    sha256 "40c55a6d0c734674b4b464a96f7c52cd71e9490fb91ea8e8259fe7915f908b2f" => :el_capitan
    sha256 "01c14479efa7e6c3e7a3eee14a6af6e9934d93ff2b1449a26a7d38ce730edf35" => :yosemite
    sha256 "cf08ab1847d628ceb2353b8cc75620f4234ff98b028a53542d55ef8800b86dd7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on "libid3tag"
  depends_on "mad"
  depends_on "libsndfile"

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "no_modplug", "no_xspf", "coreaudio", "ncurses"
    system "make", "install"
  end

  test do
    system "#{bin}/herrie", "-v"
  end
end
