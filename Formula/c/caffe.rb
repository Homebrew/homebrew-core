class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/refs/tags/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 43

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "839a67b9ca63d507107b5c30b88e407c62a91e4f6cf9f4a2271f7d137ac0c301"
    sha256 cellar: :any,                 arm64_monterey: "184737d595e4311d8dfb3e27620f65dd8d7955663c187af0bf643868faa46a5c"
    sha256 cellar: :any,                 arm64_big_sur:  "7cf4b212b6fdf9bd18a94625348f62c20becca29ec0e00b77bc6c1bdbea45ff9"
    sha256 cellar: :any,                 ventura:        "1da4910ab90d3980153d5fa3d2e1629679f1beea1d2438cbf249ba6d7fa782d9"
    sha256 cellar: :any,                 monterey:       "082ccc224264bafd4b7139140fc5461f9e442cebc37ff5c8aeeed04a0f3d0c56"
    sha256 cellar: :any,                 big_sur:        "0a4c1a98a9ca96332be624aa388dd88250cdcef2f8c2c96ee5c9f4de1479ca4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90091b481b0900bc049743ded1cdc2249d2aa70f3f441a05158778c47647a89"
  end

  disable! date: "2023-10-17", because: :deprecated_upstream

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
    depends_on "openblas"
  end

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

    args = %w[
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "models"
  end

  test do
    resource("homebrew-test_model").stage do
      system bin/"caffe", "test", "-model", "lenet_train_test.prototxt",
                                  "-weights", "lenet_iter_10000.caffemodel"
    end
  end
end
