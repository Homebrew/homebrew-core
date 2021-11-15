class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic1/archive/1.3.0.1.tar.gz"
  sha256 "9041f5c7d3720899c90c890ada179c92c3b542b90bb655c247e4a4835df79249"

  bottle do
    sha256 arm64_monterey: "d5e9edd6ea60a7c799c8d88e35f981dce913d950874ce44fa9805bb7c91c5e32"
    sha256 arm64_big_sur:  "72107347e7fd6f6ca1af6808fe3ea5b428e3dee2f733743a0d44cd9b9e67d492"
    sha256 monterey:       "b5b3fbdb47926a507b67c517346e66e1b3deba2622f915eb66409c601fe2718b"
    sha256 big_sur:        "ef5067be11a74cc8cd63e266a775ece9ebcf59c9995b630f9717d7333dbdd924"
    sha256 catalina:       "72b346f8eefbbc70abc0a67bc72265b3bec7f99e53b18418ad6835df52518f1e"
    sha256 mojave:         "a185641e0d84aae004df33923ca0612b9ba0d59c9a1d4a5fd80ebd6d1de69f58"
    sha256 high_sierra:    "98a927ebfffb3a965506102d758fe4a5e76d0c6bd732972e6b113505d28241c8"
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
