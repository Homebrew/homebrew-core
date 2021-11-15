class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2/arx-libertatis-1.2.tar.xz"
  sha256 "bacf7768c4e21c9166c7ea57083d4f20db0deb8f0ee7d96b5f2829e73a75ad0c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "90c0583fec080ec4353ab2dbb8b8ac163088e4c0f669ebc41a64462fc9c99118"
    sha256 arm64_big_sur:  "e469206c5bb34427edef5f81ca7a5a2511e2657b8acb26842a189362629d630e"
    sha256 monterey:       "effd241b3626da330df4ba4f042c25c765f66672ca037652a2bd54a6d574d84d"
    sha256 big_sur:        "3f03719e92c9606c8ea9b9dbd891fb021cb64dab0f900ccdb4461fd9e148dcea"
    sha256 catalina:       "92502b8e62cb44e1fdedd2dccba4f52e50dc84d43ba49e9701bad63068398b74"
    sha256 mojave:         "fd6ca5b5c434e60283a830f15320e40863a74d6c86fb4c5f2301cb27b6b60489"
    sha256 x86_64_linux:   "77ab00fa5362582badc7471df2b653af79e8345ea2a915cc1eeb6760de28cabd"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl"

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = std_cmake_args

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This package only contains the Arx Libertatis binary, not the game data.
      To play Arx Fatalis you will need to obtain the game from GOG.com and
      install the game data with:

        arx-install-data /path/to/setup_arx_fatalis.exe
    EOS
  end

  test do
    system "#{bin}/arx", "-h"
  end
end
