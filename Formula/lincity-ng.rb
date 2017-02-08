class LincityNg < Formula
  desc "City simulation game"
  homepage "https://github.com/lincity-ng/lincity-ng/"
  revision 1
  head "https://github.com/lincity-ng/lincity-ng.git"

  stable do
    url "https://github.com/lincity-ng/lincity-ng/archive/lincity-ng-2.0.tar.gz"
    sha256 "e05a2c1e1d682fbf289caecd0ea46ca84b0db9de43c7f1b5add08f0fdbf1456b"
  end

  bottle do
    sha256 "52e481eb39b035267c438d0c7632f003b9c0442ed009dbc560a7f087bc7924c3" => :el_capitan
    sha256 "00f2e62a528c4f6b55bbda893b4720a6c318d00eb2d30d3ff2accdcb84034f26" => :yosemite
    sha256 "e0fbca775197ab15ec9a747af1acf883aa1a5191753fb4ceceec201aaff66c33" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/lincity-ng.berlios/lincity-ng-2.9.beta.tar.bz2"
    version "2.9.beta"
    sha256 "542506135e833f7fd7231c0a5b2ab532fab719d214add461227af72d97ac9d4f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "jam" => :build
  depends_on "physfs"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer" => "with-libvorbis"
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

  def caveats; <<-EOS.undent
    If you have problem with fullscreen, try running in windowed mode:
      lincity-ng -w
    EOS
  end

  test do
    assert_match /lincity-ng version #{version}$/, shell_output("#{bin}/lincity-ng --version")
  end
end
