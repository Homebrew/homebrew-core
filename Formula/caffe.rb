class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 38

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1ff10490d3319714c13dc90cebc17dd545bb7dd34fb5745294abeb0f25cd607"
    sha256 cellar: :any,                 arm64_big_sur:  "2b0c210d2307aa2c52ebf5975a5d552ee5734b472f700f129a06b5b6b7ab6fec"
    sha256 cellar: :any,                 monterey:       "b3d275a6e61267d377de63ebd32f2f9b38b1db5d18fbe3d38166fefb28d1da61"
    sha256 cellar: :any,                 big_sur:        "0dc47d8b122659d527ffb131d58ed92222c80ba69848467150cb138f70767408"
    sha256 cellar: :any,                 catalina:       "fc743dcb1ad7c5d8d8beb3b2425782699135d2d83206e46e5f4d8183c80f946c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0f55d6ae8fa0c619bcc6a3396d93ad83ca5d2cfc480fa0928e58b9832ad823"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "hdf5"
  depends_on "leveldb"
  depends_on "libaec"
  depends_on "lmdb"
  depends_on "opencv"
  depends_on "protobuf"
  depends_on "snappy"

  on_linux do
    depends_on "gcc"
    depends_on "openblas"
  end

  fails_with gcc: "5" # opencv is compiled with GCC

  resource "homebrew-test_model" do
    url "https://github.com/nandahkrishna/CaffeMNIST/archive/2483b0ba9b04728041f7d75a3b3cf428cb8edb12.tar.gz"
    sha256 "2d4683899e9de0949eaf89daeb09167591c060db2187383639c34d7cb5f46b31"
  end

  # Fix compilation with OpenCV 4
  # https://github.com/BVLC/caffe/issues/6652
  patch do
    url "https://github.com/BVLC/caffe/commit/0a04cc2ccd37ba36843c18fea2d5cbae6e7dd2b5.patch?full_index=1"
    sha256 "f79349200c46fc1228ab1e1c135a389a6d0c709024ab98700017f5f66b373b39"
  end

  # Fix compilation with protobuf 3.18.0
  # https://github.com/BVLC/caffe/pull/7044
  patch do
    url "https://github.com/BVLC/caffe/commit/1b317bab3f6413a1b5d87c9d3a300d785a4173f9.patch?full_index=1"
    sha256 "0a7a65c4c9d68f38c3a91a1e300001bd7106d2030826af924df72f5ad2359523"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DALLOW_LMDB_NOLOCK=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_docs=OFF
      -DBUILD_matlab=OFF
      -DBUILD_python=OFF
      -DBUILD_python_layer=OFF
      -DCPU_ONLY=ON
      -DUSE_LEVELDB=ON
      -DUSE_LMDB=ON
      -DUSE_NCCL=OFF
      -DUSE_OPENCV=ON
      -DUSE_OPENMP=OFF
    ]
    args << "-DBLAS=Open" if OS.linux?

    system "cmake", ".", *args
    system "make", "install"
    pkgshare.install "models"
  end

  test do
    resource("homebrew-test_model").stage do
      system "#{bin}/caffe", "test",
             "-model", "lenet_train_test.prototxt",
             "-weights", "lenet_iter_10000.caffemodel"
    end
  end
end
