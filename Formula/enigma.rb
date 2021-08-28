class Enigma < Formula
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "https://www.nongnu.org/enigma/"
  url "https://github.com/Enigma-Game/Enigma/releases/download/1.30/Enigma-1.30-src.tar.gz"
  sha256 "ae64b91fbc2b10970071d0d78ed5b4ede9ee3868de2e6e9569546fc58437f8af"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    # This uses the git tag to get version numbers.
    # Stable releases should be tagged like 1.21.1 or 1.30
    regex(/v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/Enigma-Game/homebrew-enigma/releases/download/enigma-1.30_1"
    sha256 big_sur:      "3e9122b5f5f5fb39f3d8083d7e97bd77e40201f4db5ded91ba520fce480dc53d"
    sha256 catalina:     "cc9af7d870ae8ac80a94febb1a0440e8382513be6dba8704356917d12ad9d38a"
    sha256 mojave:       "22841ba05ef67b8b9e11345dc2a11e5ec36208408488639f6d46af83a0a3607d"
    sha256 x86_64_linux: "63f862b3d337058eaff45a57c388a6fd485c0e3a0307459bc10747e39b3e55c7"
  end

  head do
    url "https://github.com/Enigma-Game/Enigma.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "texi2html" => :build
  end

  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "enet"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "xerces-c"

  on_linux do
    depends_on "gcc"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--with-system-enet",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "strip", bin/"enigma"
    if build.head?
      system "make", "dist"
      mkdir_p prefix/"dist" if build.head?
      dist_tar = Dir["enigma-*.tar.gz"]
      odie "Unexpected number of artifacts!" if dist_tar.length != 1
      (prefix/"dist").install dist_tar
    end
    mkdir_p prefix/"etc"
    (prefix/"etc").install "etc/enigmabuilddmg"
    (prefix/"etc").install "etc/Info.plist"
    (prefix/"etc").install "etc/enigma.icns"
    (prefix/"etc").install "etc/menu_bg.jpg"
  end

  test do
    assert_equal "Enigma v#{version}", shell_output("#{bin}/enigma --version").chomp
  end
end
