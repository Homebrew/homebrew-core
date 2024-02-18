class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.0.12.tar.gz"
  sha256 "a5b088ff4c1c6c2e05e72d755bbabde8c0cbea19debea3b5a82b5d08b16cc2be"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f12fcbbb6b20aa9d75e15ff24d30efbdc074dd6e91f19c9bcc4d148b6b48e369"
    sha256 arm64_ventura:  "e0b7835c0bae053da6efae60f81bbdcd0ef4c63913d62cdb444b94e6843d69fd"
    sha256 arm64_monterey: "48cc1591eebccab94ea59778010d7cad73911190daf3fd84b79ea573ab0e529e"
    sha256 sonoma:         "117376d77083e6fe0b93f673d5385d2aca325bcac3f91e7780c4cf8e4fa55910"
    sha256 ventura:        "9309abc9efa7fd322799b24c083ec627019c3d0b4b81be5fd1be7f8a336843a3"
    sha256 monterey:       "eed826270ddff7d393a8897ce9c988a6a5a2636963c2ff43b70f3dbc44a76a6b"
    sha256 x86_64_linux:   "c1e601dceaa669a2e89c70cfd5584ad793a4f8a9bbfae6a0c4eb8b96623cddf6"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Fixes Sonoma iconv issue `end-of-line within string`
  # Remove in next release
  patch do
    url "https://github.com/ihhub/fheroes2/commit/18ab688b64bc3a978292602b27cf4542bcb07f7d.patch?full_index=1"
    sha256 "f1f1f716c4b2ef8ec99aa336fd9526e45f95b3ecfa002d398b1ec9cd955e8000"
  end

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
