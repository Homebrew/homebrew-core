class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3001213e4495dbd9233ac08e813c08585b088ba64d745325f7e4535ea78dbb6d"
    sha256 cellar: :any,                 arm64_monterey: "b4597b28bbb74064cfaea808a8df076be45e2b880ee25cb31b2fd44458c96a3c"
    sha256 cellar: :any,                 arm64_big_sur:  "d5672d80720f2c28af768c625d5edb4c692e7e736919ba51cd3b00eee7e67d12"
    sha256 cellar: :any,                 ventura:        "9ba629086f6862f2757689220f0f154f188e7130806b3186746307dd2edfc0e2"
    sha256 cellar: :any,                 monterey:       "8862898f2f33cf41525624ec33b4f5cf88503e7264f966e28113015f77d9bf5d"
    sha256 cellar: :any,                 big_sur:        "9b1a3d438c30843b6c63128238f70963281a4121695791dabae453a2c1f7715e"
    sha256 cellar: :any,                 catalina:       "bdaf5ac180b818984e89db82432c26f2b65f658b96518ecef1cf160623e44b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a89fbe55fc02cd3ccc2696f44caba3002d0f204ca2c3a63a093eab01a4c550"
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
