class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 40

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f5a96c8328e6138829acf81276427238d869cf19f1c71e24022dc2d5b5d420a"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f034785b485867f7886103c4bd3fd4bd4f540b7bb0a5b7cde01714c4b9e945"
    sha256 cellar: :any,                 monterey:       "cd851e5cba512ad56c70ddf31adcb0961e2598a540d56196bfaf3b39d4c0c904"
    sha256 cellar: :any,                 big_sur:        "a94881877f3695dbf486e63e149e0a94cfead9ae0e9bb8f7e56dacad6aa29ee9"
    sha256 cellar: :any,                 catalina:       "e080ed2516787bd3a43e627488e2ada20d60aa166b3919dc87e83cefe9fd35e1"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
