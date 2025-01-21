class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.5.tar.gz"
  sha256 "b860e5cc0064d15f47e1b1e04b4c75bd8200084260da860632b61fa2899fcf83"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "febed7ae920afd6ecaf50a6b864bf10c77c7dbe10d06ea1c17eda74473fe169a"
    sha256 arm64_sonoma:  "12d505f0fab20bda6081438e72b6e3089099d94417d2b3fcb22923fd6bfabaf5"
    sha256 arm64_ventura: "b6d414ccc9e5bd794d4e8f5421a40a6995e00490ccae65ce242d8c48b240657b"
    sha256 sonoma:        "da74c6e86c4861698dee79dd5f0978d89db2f9cba62e42998fc7741bdfd06a6b"
    sha256 ventura:       "c0fc1d518bf6697d2a877cfd00ef53da5d3e40a647499acd0b4168180a544905"
    sha256 x86_64_linux:  "501bafb0aba102ffc9acb468cee08acefb7fbb591c945feb93d1533947b52ad6"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

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
