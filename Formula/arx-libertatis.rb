class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.1.2.tar.xz"
  sha256 "82adb440a9c86673e74b84abd480cae968e1296d625b6d40c69ca35b35ed4e42"

  bottle do
    cellar :any
    sha256 "c9501246f02d0a560b5c66206f11a77f2398806d1a195280b5efbdb057924891" => :el_capitan
    sha256 "4ac17cd6760c07a2fc01902346fd96e25253b0ee6cf171e1ed0855c82d1604ee" => :yosemite
    sha256 "8f1938381423b45d798c8a2665484b4f9a09b8070443b80986e935d07b0410af" => :mavericks
  end

  option "without-innoextract", "Build without arx-install-data"

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract" => :recommended
  depends_on "sdl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    if build.with? "innoextract"; then <<-EOS.undent
      This package only contains the Arx Libertatis binary, not the game data.
      To play Arx Fatalis you will need to obtain the game from GOG.com and install
      the game data with:

        arx-install-data /path/to/setup_arx_fatalis.exe
      EOS
    end
  end

  test do
    system "#{bin}/arx", "-h"
  end
end
