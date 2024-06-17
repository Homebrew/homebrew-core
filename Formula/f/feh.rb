class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.10.2.tar.bz2"
  sha256 "5f94a77de25c5398876f0cf431612d782b842f4db154d2139b778c8f196e8969"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7e26f07565d465eb713ed4a22495248ec9ac8875fe348706a195e96785028ccf"
    sha256 arm64_ventura:  "ae59ccc9311345d94a0f2aecc52d50427ff082bec39069ea48a525281224fede"
    sha256 arm64_monterey: "25919221f73fee1f13d5e89da2ac8143bf9f63adc2c5c47baf11e760cb299a10"
    sha256 sonoma:         "1d0d311f35fdc6dc1fac964c3ec0bd275aa499122be2f5ce59c929948c6bd3ee"
    sha256 ventura:        "4d4297db146d5ac4862198cbea82b917f59d543311d0dd85935c884e692eaf64"
    sha256 monterey:       "00cf0045980a4cfb67b44eeaff9dbf1ed7ec56282c1239619639e7ed7e9ea1e2"
    sha256 x86_64_linux:   "5b490537a2437ee8a19f6f4c58471c152ec5232babb6af606a3207db5273e017"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
