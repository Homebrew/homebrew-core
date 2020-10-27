class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic1/archive/1.3.0.1.tar.gz"
  sha256 "9041f5c7d3720899c90c890ada179c92c3b542b90bb655c247e4a4835df79249"

  bottle do
    sha256 "72b346f8eefbbc70abc0a67bc72265b3bec7f99e53b18418ad6835df52518f1e" => :catalina
    sha256 "a185641e0d84aae004df33923ca0612b9ba0d59c9a1d4a5fd80ebd6d1de69f58" => :mojave
    sha256 "98a927ebfffb3a965506102d758fe4a5e76d0c6bd732972e6b113505d28241c8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "pcre2"
  depends_on "portaudio"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mimic", "-t", "Hello, Homebrew!", "test.wav"
    assert_predicate testpath/"test.wav", :exist?
  end
end
