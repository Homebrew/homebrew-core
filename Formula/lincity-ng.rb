class LincityNg < Formula
  desc "City simulation game"
  homepage "https://github.com/lincity-ng/lincity-ng/"
  url "https://github.com/lincity-ng/lincity-ng/archive/lincity-ng-2.0.tar.gz"
  sha256 "e05a2c1e1d682fbf289caecd0ea46ca84b0db9de43c7f1b5add08f0fdbf1456b"
  revision 2
  head "https://github.com/lincity-ng/lincity-ng.git"

  bottle do
    sha256 "4ea8b0d4afe937e6ffdd5ff7c92fd84fdfb23c35f5dd8a0bdcb015f79a7ba5b7" => :catalina
    sha256 "5909e4a6c9cfe47aafd4fb4c5dd26016cbe096945faa485d377fe2c423b3caca" => :mojave
    sha256 "bdfe153ca219084bf621c031612c8b86b02911e64d6fa154422812aee7de8d76" => :high_sierra
    sha256 "cae5f270842c10affb29d6f9c592a96913d9ca630c49d22afa03cba6d3a6121c" => :sierra
    sha256 "b9f326c678a9317f141ad13749cb4075ab42144855254d344de15bc22c4020e5" => :el_capitan
    sha256 "6eae33edda53f256caa2fde01d334bc19b2c9810c8cf8e039ad1094c71619691" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jam" => :build
  depends_on "pkg-config" => :build
  depends_on "physfs"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    # Generate CREDITS
    system 'cat data/gui/creditslist.xml | grep -v "@" | cut -d\> -f2 | cut -d\< -f1 >CREDITS'
    system "./autogen.sh"
    system "./configure", "--disable-sdltest",
                          "--with-apple-opengl-framework",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "jam", "install"
    rm_rf ["#{pkgshare}/applications", "#{pkgshare}/pixmaps"]
  end

  def caveats; <<~EOS
    If you have problem with fullscreen, try running in windowed mode:
      lincity-ng -w
  EOS
  end

  test do
    (testpath/".lincity-ng").mkpath
    assert_match /lincity-ng version #{version}$/, shell_output("#{bin}/lincity-ng --version")
  end
end
