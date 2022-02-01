class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 35

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e9a6b7d5319b06b9f804e86ed609663951e113455df8bd57a0f7300f8dab0335"
    sha256 cellar: :any, arm64_big_sur:  "a2fab68055a79c1312b04b283d6034a206ec254d8daf0917e7ac62432d0c5d91"
    sha256 cellar: :any, monterey:       "c657f6c2d50f44d7b8cc329a9b0280ceeaa801596247ba38d3cccbdeb2530d72"
    sha256 cellar: :any, big_sur:        "90ebcb88034a191447fe98ae5990c3c7563141d1122b6b21d4acf5771cbacd92"
    sha256 cellar: :any, catalina:       "d7381ec7e78e3a2e373715bf5c6627694521c2ad80f8e8dde421ef31d7f9c56f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "hdf5"
  depends_on "leveldb"
  depends_on "lmdb"
  depends_on "opencv"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "szip"

  resource "test_model" do
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

    system "cmake", ".", *args
    system "make", "install"
    pkgshare.install "models"
  end

  test do
    resource("test_model").stage do
      system "#{bin}/caffe", "test",
             "-model", "lenet_train_test.prototxt",
             "-weights", "lenet_iter_10000.caffemodel"
    end
  end
end
