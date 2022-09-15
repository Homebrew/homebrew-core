class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 41

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b541442a6d65a4bd33be673e3e65600e03572d2a8ba7297ce591a45dff1a936"
    sha256 cellar: :any,                 arm64_big_sur:  "6bd1fbd55fb47274ca9a00742ce531a6489be521a1a8e5854609470403881b98"
    sha256 cellar: :any,                 monterey:       "005bad8638ff49a119722ab5eac1c570f07fd233653a6a2de2dac546a39fc994"
    sha256 cellar: :any,                 big_sur:        "f3296808a8390757a22c4c6bff6581e8393b22cf9fead83b9027881d22b29f0d"
    sha256 cellar: :any,                 catalina:       "19fd2287e31575e952b735c707a050bd94a8001ebe0471a51856d60ae0a0c348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105f09dd49c082b65850593f88c9c39dc6f0a3aee093b3d50a7a282a8aa3235e"
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
