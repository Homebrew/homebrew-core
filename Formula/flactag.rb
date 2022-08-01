class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "172a74591af446c3f610df5b16f2cb22185e386aafa66782755af02b80b2626c"
    sha256 cellar: :any,                 arm64_big_sur:  "7bcdf781895e83c286433dfc0c7806c1f97690aa229e27ebdfc7e1989418e18f"
    sha256 cellar: :any,                 monterey:       "6ae8484da21f3b55d40b3036b33974319af845e88ee1163a4134f1a7f63d43b1"
    sha256 cellar: :any,                 big_sur:        "ca60ff48388d4d2ce6dee37f306849700832c81f13c56f65e9c7327e55e0f36e"
    sha256 cellar: :any,                 catalina:       "91f3ba33647b5b188c3ce9790004c67a8339c2d165c3cb9b5cccf57a37105181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da220ed1b38e1a36e1fe40f01b6627bab8e78e94f46e84dc8f654ea36016cede"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "s-lang"
  depends_on "unac"

  uses_from_macos "libxslt"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ed0e680/flactag/jpeg9.patch"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end
