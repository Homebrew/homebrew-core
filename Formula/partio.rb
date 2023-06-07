class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.14.6.tar.gz"
  sha256 "53a5754d6b2fc3e184953d985c233118ef0ab87169f34e3aec4a7e6d20cd9bd4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f23723988ee0c4fd13e2ef3999cd48cdc0713e2e68b08f1e1e8fb64bfb72735e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8779e2d241646c96f0b6fa412219f0556b69ff03d9dd98d6a9ecb1172baccf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40c077714c5b73b2d1eca4b57054262ca3e4bef68ec9827ab39f205a3d7d170b"
    sha256 cellar: :any_skip_relocation, ventura:        "39707a6cc21e84edc6cae4c82637600e049b521e92fe239dcc545b9c8bbc79dd"
    sha256 cellar: :any_skip_relocation, monterey:       "247dad3b9b36c9a485ad9142e3840e0dd503547c8faf0b6a3ec6f92195278b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fa3eb20d12124955b39eb260a96586bedd4f254d5bbae6f52a0cdf186d380ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7788987e0e5e2dcfc950be3b9f229f7061c2b6f0a6f6decda35bdf909497d1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.11"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
