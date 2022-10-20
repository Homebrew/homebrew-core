class LincityNg < Formula
  desc "City simulation game"
  homepage "https://github.com/lincity-ng/lincity-ng/"
  url "https://github.com/lincity-ng/lincity-ng/archive/lincity-ng-2.0.tar.gz"
  sha256 "e05a2c1e1d682fbf289caecd0ea46ca84b0db9de43c7f1b5add08f0fdbf1456b"
  license "GPL-2.0"
  revision 3
  head "https://github.com/lincity-ng/lincity-ng.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "090e1df14eb8311c8513d72bc733fb342a1f50a637349651f8cdeda99cf3fc50"
    sha256 arm64_big_sur:  "01d64e52421741c74326b51857baa6e9edd4a44a4f73d11c0e7e8da0fc8174ec"
    sha256 monterey:       "29e668a93a01b16751d4f33b0ed6191143edfbd40a5809f7727b0a71f162b480"
    sha256 big_sur:        "7fbf9b693c4af73787f4264fd89c9a37b57c0920a09ef37900a628603ec08e65"
    sha256 catalina:       "2dedf12e64b833ec52060150a25ec7d60830e6a210d7758261cebc9214489537"
    sha256 x86_64_linux:   "1607207cc36f7e17cff98834551bbcced41b48357376855f2ceafe51883fd491"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jam" => :build
  depends_on "pkg-config" => :build
  depends_on "physfs"
  depends_on "sdl12-compat"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    if Hardware::CPU.arm?
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, "mk/autoconf/#{fn}"
      end
    end

    # Generate CREDITS
    system 'cat data/gui/creditslist.xml | grep -v "@" | cut -d\> -f2 | cut -d\< -f1 >CREDITS'
    system "./autogen.sh"

    args = std_configure_args + %W[
      --disable-sdltest
      --datarootdir=#{pkgshare}
    ]
    args << "--with-apple-opengl-framework" if OS.mac?

    system "./configure", *args
    system "jam", "install"
    rm_rf ["#{pkgshare}/applications", "#{pkgshare}/pixmaps"]
  end

  def caveats
    <<~EOS
      If you have problem with fullscreen, try running in windowed mode:
        lincity-ng -w
    EOS
  end

  test do
    (testpath/".lincity-ng").mkpath
    assert_match(/lincity-ng version #{version}$/, shell_output("#{bin}/lincity-ng --version"))
  end
end
