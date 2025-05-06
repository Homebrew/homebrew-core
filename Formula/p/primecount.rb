class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.17.tar.gz"
  sha256 "f42abde9cdf133d66ef20296c871e7326ee9bf7a026de5885be6cb8b18affcb7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd191a8713e1cebb4c9e7c63e727a3d98a4c2c59cf139f3183680dab65300f11"
    sha256 cellar: :any,                 arm64_sonoma:  "3571b935c636074a568b1de2ff672864cf96aed1dea511253212b01a975d3b9f"
    sha256 cellar: :any,                 arm64_ventura: "bf6acf0ab6d48b10a667f2dd8674fc1a96b9d380988240cf3cf116bd8bbec91b"
    sha256 cellar: :any,                 sonoma:        "79a1ea2c7bd5124d5882caa28609c293d22b68a71bca2ede05ad5fbe147e38dc"
    sha256 cellar: :any,                 ventura:       "ffff8ef56217acc89e263130120e1977114a76b4fe14883685fc9425ab76f33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8197787ecf566640c18ce142183ce7ba90d37c315c6e55e45e5550503b7c1ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175a17d85159304392d9a7011a9fb19b2ae46fa0553bb02d4a387758b273e1be"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
