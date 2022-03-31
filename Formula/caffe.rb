class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 37

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "608d5c9d8187a87f7a25d42a81c0b15737259ab2833c0b3f4834764e9d57c2e3"
    sha256 cellar: :any,                 arm64_big_sur:  "8813e39f2332b858b1b53164931195adf152f9e2e478311c86105706346467e0"
    sha256 cellar: :any,                 monterey:       "e42633d6526e66e520c5df8a6718b294578e58c952375618de274d5cfb82eb51"
    sha256 cellar: :any,                 big_sur:        "c4c0f2c54a445d6671f5bc82ad2018e86294a2c47402df10f6e51ff72c410253"
    sha256 cellar: :any,                 catalina:       "fcbbbaebf116517e538f0902b6f96e9910043100c7aa65e92004e00625bc80f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe5f232d7370d7e682624763c4416a6cfe7dc6158e3ec303bd9f2b816f0792c"
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
