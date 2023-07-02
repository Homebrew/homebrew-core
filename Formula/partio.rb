class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.17.0.tar.gz"
  sha256 "8f72db005e7ddf1bab54ee504692c0cdfc62080f31e4f3689c99ad7531531239"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691816970f33043030e0cec360b8e04c1eb109ef085540fec663f7fda12a988f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed02c6ac94672aec9217278003d5a0e86796882682d0d99a850e68a0b4060a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1ee5c7f3a9d5a27962f890e1803aa5f2afb5197d9e4893c829bec1801e052a7"
    sha256 cellar: :any_skip_relocation, ventura:        "566de7d88cd3780b143087a067203f2b9f24bb4db45fb4dcba83548a482d0b72"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef17e9087c2ada7ed17abd5ab74cb7be8311465d7b3be8402a0cea6a173d97b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c57b9b1f56e15393b33b2130bdf21199e7b2e86839c7d08254cc551ea0c70723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9840c0630ae7d576cd6f1a897f80bf1ad3e74609172d42019cb40144d90d3056"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "googletest"
  depends_on "python@3.11"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?
    args << "-DPARTIO_GTEST_ENABLED=ON"
    args << "-DGTEST_LOCATION=#{Formula["googletest"].opt_prefix}"

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
