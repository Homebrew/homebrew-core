class EspeakNg < Formula
  desc "Multi-lingual software speech synthesizer"
  homepage "https://github.com/espeak-ng/espeak-ng"
  url "https://github.com/espeak-ng/espeak-ng/archive/refs/tags/1.51.1.tar.gz"
  sha256 "0823df5648659dcb67915baaf99118dcc8853639f47cadaa029c174bdd768d20"
  license "GPL-3.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  on_macos do
    depends_on "pcaudiolib"
  end

  on_linux do
    depends_on "libpcaudio-dev" => :build
  end

  def install
    system "mv", "CHANGELOG.md", "ChangeLog.md"
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "h@l'oU\n", pipe_output("#{bin}/espeak-ng -qx hello")
  end
end
