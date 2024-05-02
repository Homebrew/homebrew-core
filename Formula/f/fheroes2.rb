class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.0.13.tar.gz"
  sha256 "eb7f960e77ee8012e5bbab385baf4959797e578454ace82574a3c6fee24f94c8"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "707fee6937afb9b7a48f31d91a3c6bd1f76458367f5884525050bc96fb68b1d4"
    sha256 arm64_ventura:  "5304ab6d4c46389a1cd8b90a54517ca7a3ef659b406c84441ac7275f2b68e24a"
    sha256 arm64_monterey: "5347faa70d9e59ea2cd8268895e538604319f58f6a26d7f79c81186b1b5d7344"
    sha256 sonoma:         "5eb13df49fcd61a8312b6df5192ba975b4526581eecdbf461a0d9076ff057c3e"
    sha256 ventura:        "470c2366c18365f284413bb0ad708cc8c53437f05071b625d9dbf53dc3afcbba"
    sha256 monterey:       "61e1ed752bf45e9b6a65c121c9e841790829c56ccc9ed1bbd57f0a0ba38443a9"
    sha256 x86_64_linux:   "5b466d1d84f397fd1ad6e043b8cfceab234c75edb6c52c743da3ff00014876b8"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
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
