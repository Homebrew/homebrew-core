class Herrie < Formula
  desc "Minimalistic audio player built upon Ncurses"
  homepage "https://github.com/EdSchouten/herrie"
  url "https://github.com/EdSchouten/herrie/releases/download/herrie-2.2/herrie-2.2.tar.bz2"
  sha256 "142341072920f86b6eb570b8f13bf5fd87c06cf801543dc7d1a819e39eb9fb2b"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "6432c7e843bd2580b1b736d4df4cdc37a8e80133ec46e7707cd379e662f5f2ed"
    sha256 arm64_big_sur:  "2e6dfaa27fef44c8bc0b4caf3250fed6dfcfca8cbdb5f8104a0ba1dc781371c1"
    sha256 monterey:       "22afb3f4e7d5021cfd0dea01a4f64b8259134ce05b425882f118d2b40f9764ca"
    sha256 big_sur:        "41be543b395d9650113133b77d4d03d37febc9ecba23cb5f85abe8deb681f011"
    sha256 catalina:       "8f1d86edb139e3385ac225852623f9c5018779a81b10c307a3ae872c1e64392d"
    sha256 mojave:         "4e3258f904116ff2eebbe9436ff3ea3bae676fe15bd0ea193d1d934353e2ffe3"
  end

  deprecate! date: "2021-02-09", because: :repo_archived

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"

  uses_from_macos "ncurses"

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "no_modplug", "no_xspf", "coreaudio", "ncurses"
    system "make", "install"
  end

  test do
    system "#{bin}/herrie", "-v"
  end
end
