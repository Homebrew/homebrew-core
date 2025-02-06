class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "1dd62d3febd8eb75dcb6d5d217b82a32019c8345602b86c2b0ce57f0ad686247"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00e90f3ddb8c7f3b1dc07b6818ea96a61ca841270efe2c9486d13254ff80a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be88e891b14b04cbd0585f325ceb4f15da560b70aaebca000059d84755ce279"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0206d3a3b18abec4f5b5f03d1bb07637b4ba4ff1b0c7bf05b6d31c78e86cdcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f0fe12b45dfbcb0e38f8ae9179474383d7fef97e32caa5a298bce1214bcd92"
    sha256 cellar: :any_skip_relocation, ventura:       "15f4eca641faac55035d54b22d16e18d02e75f5d89110d5526a28377678f361b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb170d3d5fb46eb5cf9fcb258ceea9c66ca7d53ee3001a116036d901134fe8bd"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.13"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

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
