class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.1.2.tar.xz"
  sha256 "82adb440a9c86673e74b84abd480cae968e1296d625b6d40c69ca35b35ed4e42"

  head do
    url "https://github.com/arx/ArxLibertatis.git"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git"
    end
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
    args = std_cmake_args

    # The patches for these aren't straightforward to backport because of
    # other changes; these minimal inreplaces get it building.
    # HEAD is fine, and the next stable release will contain these changes.
    if build.stable?
      inreplace "src/platform/Time.cpp", "clock_t", "clockid_t"

      # Version parsing is broken in the current stable; fixed upstream.
      # This hardcodes the current version based on data from VERSION.
      inreplace "src/core/Version.cpp.in" do |s|
        s.gsub! "${VERSION_COUNT}", "5"
        s.gsub! "${VERSION_2}", "10"
        s.gsub! "${VERSION_0}", "1.1.2"
        s.gsub! "${GIT_SUFFIX_5}", "+Homebrew-1"
        s.gsub! "${VERSION_4}", "Rhaa Movis"
      end
    end

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    mkdir "build" do
      system "cmake", "..", *args
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
