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
    rebuild 1
    sha256 arm64_sonoma:   "eb97f820980c15fa22c555ae890d04855a7d8701056bff965990d74530870aaf"
    sha256 arm64_ventura:  "c34f334bc9a553a1e0f30b0baffd210db6f2924dc8011a522bda492c26faf4eb"
    sha256 arm64_monterey: "57115fc429778525669b819d133702dbac203729101f63d6c9090dee7832d725"
    sha256 sonoma:         "579c42f69c3506d52a1e60cd1ccce65409d0d0c85902f86e66797a9e9cd7d3c7"
    sha256 ventura:        "5d7cef1d2081a07deed4e2f08af84f6285bfc43311d1007c86ac57f570490791"
    sha256 monterey:       "0c53a32123714e22998bc9c15758dd35c1aba56716c773df5d8893f5ade208eb"
    sha256 x86_64_linux:   "aadd4306040e0ef69e6c840d0966f8b397a553fa83ce2e044d046ca7da33eb82"
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
