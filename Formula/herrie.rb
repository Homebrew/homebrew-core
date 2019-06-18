class Herrie < Formula
  desc "Minimalistic audio player built upon Ncurses"
  homepage "https://herrie.info/"
  url "https://github.com/EdSchouten/herrie/releases/download/herrie-2.2/herrie-2.2.tar.bz2"
  sha256 "142341072920f86b6eb570b8f13bf5fd87c06cf801543dc7d1a819e39eb9fb2b"
  revision 1

  bottle do
    sha256 "689038931cdc86fee22b0e4217bdb4eccc5c7591254c67300aade0637ae1dc5e" => :mojave
    sha256 "65631ae69a925bf48a3e4167807b13c36988db1bd1d4f7ed311356da39344c9a" => :high_sierra
    sha256 "f794117e72309d83bc947463032c262a7341d21eabc5099712016d0f078804f2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "no_modplug", "no_xspf", "coreaudio", "ncurses"
    system "make", "install"
  end

  test do
    system "#{bin}/herrie", "-v"
  end
end
