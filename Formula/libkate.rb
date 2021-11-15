class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/archive/p/libkate/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/libkate-0.4.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_monterey: "3b2b393791903423df63ad4da2e8b15d164096347ad62ffc21b0bb075ebca8e4"
    sha256 cellar: :any, arm64_big_sur:  "fb7f9d49f2a91063930005f2cb81d435036b188877691c2fc371d592a885c0cd"
    sha256 cellar: :any, monterey:       "80fa311e6a996435b69035822a9d253600e878771255abf150734f054ebed665"
    sha256 cellar: :any, big_sur:        "5984d97cdd6aa411e27b1360e693f55fe3ecd073a5a6531f725533b738aa55f8"
    sha256 cellar: :any, catalina:       "2b144fcc2436f43c099a3e5ce8b8a0b387db8fda62b5e0aaaf7dd5d6d92054dd"
    sha256 cellar: :any, mojave:         "8f075fa46eccd65fe664e8caf42754b6d03ff1fa7f305566287af0cd6e72b396"
    sha256 cellar: :any, high_sierra:    "65f687ae05918aa2f2fb4e27f384d6645a0f64231e8dc9343c8435347895d792"
    sha256 cellar: :any, sierra:         "e7b6c1288455b12044889d768b4593a7a08beac5c4c2534f24565adb58f4a9b5"
    sha256 cellar: :any, el_capitan:     "244a27eb03227b1455bea4ffd9f8a73ccd660389c44e9719d62bba1a4247bdf6"
    sha256 cellar: :any, yosemite:       "473e0de088ba513006bb5212fd9ca21390d848c9cd5e33a7951ee3cba24220ac"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"katedec", "-V"
  end
end
