class Mp3splt < Formula
  desc "Command-line interface to split MP3 and Ogg Vorbis files"
  homepage "https://mp3splt.sourceforge.net/mp3splt_page/home.php"
  url "https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.6.2/mp3splt-2.6.2.tar.gz"
  sha256 "3ec32b10ddd8bb11af987b8cd1c76382c48d265d0ffda53041d9aceb1f103baa"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "867a665c9465e82d864910185387d4df79bced27f9121ccff36bd2f32524820e"
    sha256 arm64_sequoia:  "2d21b2a3b74e156a07882dfc20c2707bf836f011b914c88f6245a06230eacfdf"
    sha256 arm64_sonoma:   "173c1125749f0ecc643c6b98b9b0d38f60c0e7521a6cc0cdcfef9a076e03953d"
    sha256 arm64_ventura:  "4e6894c387e086d64cb6ca49c9b980db9bd005244f6cde36408d362a4aee80d7"
    sha256 arm64_monterey: "49093f6c535038ac74f901f3ec328da4611621c554c9fd016170e7609b2bacac"
    sha256 arm64_big_sur:  "991b32e34ed74df29e4fc4a5507079aade0cb8edd0dd32569ece51bda3a56be1"
    sha256 sonoma:         "ff82187f8d9e0609554d79b6a342ce374b9ea60e2e9d9c092571910cb9435ff6"
    sha256 ventura:        "94f427450b774e0ad378acee6265be5ea628cd7ff38274bd3f1aa3516b414138"
    sha256 monterey:       "6095cb447c23f8b7c736f858e3420c50b2b21134afea5c319873738c895debc6"
    sha256 big_sur:        "2bf269ede24f7a0b067a510f355d503a1424b1fa5599a019093cc75efb10c7da"
    sha256 catalina:       "8d020baec2beb1f7f24223ade4f40b758b2dee3329c71aa69929b7dde620bfac"
    sha256 arm64_linux:    "7c54aa0ebc5caa53ab0f8a09d55c9e9f7ff7226a688a31fb74aa38f4fe8c0e25"
    sha256 x86_64_linux:   "5827fe65a9230261acc5309197b66205d2c72492d58ac2ed2b6a4d38632fea66"
  end

  depends_on "pkgconf" => :build
  depends_on "libmp3splt"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mp3splt", "-t", "0.1", test_fixtures("test.mp3")
  end
end
