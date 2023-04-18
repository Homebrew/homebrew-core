class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.3.tar.gz"
  sha256 "3e4fac26d8c9e9008ecea4ae5fc414c658998fce4ba75835058b1a71d3516002"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "972faf5daee67d44d56e581c2cf9fb1a99f947a154b4a97c4e3b1cad4c361d31"
    sha256 cellar: :any,                 arm64_monterey: "b01baa24f8671a527bf75830f8137a92df0777e9b6be2940b587819a490f361d"
    sha256 cellar: :any,                 arm64_big_sur:  "cbfb1f586802bedbe45facdf35cd91d58efdfe55633372bc341557aac7056138"
    sha256 cellar: :any,                 ventura:        "abdf023064d96bac1bada9bb6197428771a3e4991989b1851e27d516134b6d43"
    sha256 cellar: :any,                 monterey:       "e68a7deee524d867c5393a7106efcfce02c4cdeed49deccca2df11fff9b9ce25"
    sha256 cellar: :any,                 big_sur:        "e64aee4414f68057d77210c73a81b457872a87d9bb7231219616a6d5db82f694"
    sha256 cellar: :any,                 catalina:       "8a94e44a680df9c862353a5cce4fbbb71fa8b52feda12d4af0ac9f9b12146069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb47aff1c07d626c790e099272b0baa508404b35d59381c9816a28320920406"
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
