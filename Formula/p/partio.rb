class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://www.disneyanimation.com/open-source/partio/"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "e60a89364f2b5d9c9b1f143175fc1a5018027a59bb31af56e5df88806b506e49"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa8064d24c572ed1cfb7721bb6cfb0552b4b565ce702c51e2040a8d53ccc7bcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8ebc2b35475e030e86b69e4ad7eab359ddc2fa24e5141982f10a199737aec41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "510fbaf0a745d1bc5241d325deb63dada2369059703022654874eaaee2308a0f"
    sha256 cellar: :any,                 arm64_linux:       "596de5fcd13dda20ba19a26572a571bf2871f16ba31eec996f39f3e76e971d99"
    sha256 cellar: :any,                 x86_64_linux:      "4bdf4326dbd61c5f2810ec12cc2275d964e388797fd9c4094cab0df05d7eaa02"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.15"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    system "cmake", "-S", ".", "-B", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "doc"
    system "cmake", "--install", "."

    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
