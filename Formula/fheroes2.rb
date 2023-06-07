class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.4.tar.gz"
  sha256 "2fe965fcd069618c0bf4e31a560d90345f4854feec0b36a785c3417dcd7e05d1"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "bd94ce5e65338472062fdcef11092ea5d9be940314d5fdb8cfdba82614ba7a5d"
    sha256 arm64_monterey: "9d14b860afcf8664bd76ea1cd85b5787f7944b6805bd854ebb528de960522dd3"
    sha256 arm64_big_sur:  "df31529d30c214b126ffd1cfa1418f92b482b6d910512cfe0a37d126e1fb8f39"
    sha256 ventura:        "09757ec4e9c5846323028b7ff4c3f72b992c0e2a0739a4faea4451b8b5c181a0"
    sha256 monterey:       "92be30fd081cf12410ddf31f46c2f88a04e5523f0e12794f51b9105c8c801c71"
    sha256 big_sur:        "5b44847a267c6a178d445c0c66522a2d2753737cff2c4b735948494ddc85701e"
    sha256 x86_64_linux:   "01ee7757ba93b0f9b755525e9b738a698132e5a9fe1ce64625ff6d1539b77ba5"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      line.include?("fheroes2 engine, version:")
    end
  end
end
