class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  license "ISC"
  revision 4

  stable do
    url "https://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
    sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"

    depends_on "glew"

    on_linux do
      depends_on "gtk+3"
      depends_on "libx11"
    end

    # Fix macOS OpenGL initialization. Remove in release after v8.1.
    patch do
      url "https://github.com/openclonk/openclonk/commit/1487ff02273975e9a7ea5f3046884c2ebf254333.patch?full_index=1"
      sha256 "d42821d13bc698435058fbd9135c5e8eb178c835afbc8fca8c6b76bdecbcc563"
    end

    # Fix Linux build to help find alut.h. Remove in next release.
    patch do
      url "https://github.com/openclonk/openclonk/commit/15e58576894f5735af390164eb15e609344f9331.patch?full_index=1"
      sha256 "af84dc82b85c2b2ae63738badf604745002ddeb2e285fb7911b7ccdf5d4497eb"
    end
  end

  livecheck do
    url "https://www.openclonk.org/download/"
    regex(/href=.*?openclonk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7934144ac831d263bb0c51284f06f2bcac0004cf395d0404c52b1f3bf1c0189b"
    sha256 cellar: :any, arm64_big_sur:  "ebd7f7efa0efc4c70b14071e98a5f2d314c16e5b6f28fe11257738619f0c813b"
    sha256 cellar: :any, monterey:       "4210b30b0f2c1b7090eee8aa91c325a125f8305f65a3305066ac554ff84619f8"
    sha256 cellar: :any, big_sur:        "1f4cca43144a36b7d6eeb24d9d3cefc84b591fb20abc503ecca7e73fc26b07ca"
    sha256 cellar: :any, catalina:       "95f44dd3686157a5185f1452f46515160347cef55237aac391edfabbbeb0c5de"
    sha256 cellar: :any, mojave:         "688963d2df4cd964a51bed317cf656137d5e8d668b457a7cef89e8302ac02f49"
    sha256 cellar: :any, high_sierra:    "87779de2d3cfa0dc1880fa45226e3f434ecca4409565db5e8bf278c225487da1"
  end

  head do
    url "https://github.com/openclonk/openclonk.git", branch: "master"

    depends_on "libepoxy"

    uses_from_macos "curl"

    on_linux do
      depends_on "miniupnpc"
      depends_on "sdl2"
    end
  end

  depends_on "cmake" => :build
  depends_on "freealut"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "tinyxml"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "openal-soft"
  end

  def install
    # Disable copying libraries into macOS app bundle by overwriting script
    File.open(buildpath/"tools/osx_bundle_libs", "w") { |f| f.puts "#!/bin/bash" }

    # Remove unneeded bundled library to avoid default fallback in build
    (buildpath/"thirdparty/tinyxml").rmtree

    # Modify Linux install location for openclonk binary to bin directory
    inreplace "CMakeLists.txt", "install(TARGETS openclonk DESTINATION games)",
                                "install(TARGETS openclonk DESTINATION bin)"

    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    return unless OS.mac?

    bin.write_exec_script prefix/"openclonk.app/Contents/MacOS/openclonk"
    bin.install Dir[prefix/"c4*"]
  end

  test do
    system bin/"c4group"
  end
end
