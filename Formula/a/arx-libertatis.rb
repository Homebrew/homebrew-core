class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2.1/arx-libertatis-1.2.1.tar.xz"
  sha256 "aafd8831ee2d187d7647ad671a03aabd2df3b7248b0bac0b3ac36ffeb441aedf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "53d4828b343a70fd7a3801c3c245a15ca140f3426db4ee57a2968397dc6450e8"
    sha256 arm64_sequoia:  "e60d7ed4b0a7ff3b132efb97907d8203a0e501f292866d17ab9b2773376b44cd"
    sha256 arm64_sonoma:   "2c520ea9e3ce0eb1066cd47fd192e73bda08a3e27b39b1efa6b5dcef7614dedf"
    sha256 arm64_ventura:  "1db7612e1dbbe5d1515b7578a2c20a3b62dd4f65c37257237d10bf7e48723448"
    sha256 arm64_monterey: "9fd235faef3f4cac1fa1bc33acace5545839c5bf9a4344793225f734dc0f4b7e"
    sha256 arm64_big_sur:  "5b7dd893fd8ab89d9265dc031d48781b14437ba175265f89a316a0d60686927e"
    sha256 sonoma:         "57d56bfaf644da9ad8cfda24e22bef0e474bd46d5ad4d5a3ffd6279b7d5777bf"
    sha256 ventura:        "2969e73fdbd0e6d7c8a72891440da7ea868bcdb35776fafb425e81f369d4df6d"
    sha256 monterey:       "d9c218e036852e73dea349e17eaa6e03358f7118bd41acd98a5f4bae7b25bc9d"
    sha256 big_sur:        "e855dfe524dd05d0ebf94acee4cb2e74f2037d0c4c44eb76fd5f49fbbb8477f8"
    sha256 catalina:       "a8a9036477373bd0065f739c0bbc8bd6e20b09da4d643f20483ab6aec6a6d289"
    sha256 arm64_linux:    "a6feb6bee70f09bafb43c03d91727cad508dac8176a2858d8f4ef761121c78f4"
    sha256 x86_64_linux:   "fcdc6dcedd23cc35e9bf57f97b4aa5946fe36adc3ffc9e15140224f79cc7d14f"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git", branch: "master"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
  end

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = %w[
      -DBUILD_CRASHREPORTER=OFF
      -DSTRICT_USE=ON
      -DWITH_OPENGL=glew
      -DWITH_SDL=2
    ]

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    output = shell_output("#{bin}/arx --list-dirs")
    assert_match "User directories (select first existing)", output
  end
end
