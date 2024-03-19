class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "56ece0a419d62eaa11e39022fa27c8ed6d5a9b9eb7416cc5a0fdbeab07ec2f0c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef550d42c8097e4bea9ca7543b72d3ed40e597dd25c1ad2a6a501b4f63525df9"
    sha256 cellar: :any,                 arm64_ventura:  "3a3d3fa6342d689f10f613925903be22e7facd9336c1a45727e52ab1cb45001f"
    sha256 cellar: :any,                 arm64_monterey: "f4018c8f975b35daac3d18292d071951dfa44504ca7395b15e7459bb7857050f"
    sha256 cellar: :any,                 sonoma:         "53379730b560a7f052a012ec2a0b737d07d82d75a07fe4bc4a15fe7f65c5d938"
    sha256 cellar: :any,                 ventura:        "8a4df73b9d6753f5470cd82cafe9574b52bb6328017b12c6d17bd293c0a4cfca"
    sha256 cellar: :any,                 monterey:       "8f3121a6d49431aacfc93bcc59a98573cbbd99cc6683196b412b267064b9775b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7039257213591de45492e514610f7f94b0463c8dde4705238d16bed04eecb536"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = *std_cmake_args + %w[
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
      -DFAISS_ENABLE_C_API=ON
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-B", "build", ".", *args
    cd "build" do
      system "make"
      system "make", "install"
    end
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
