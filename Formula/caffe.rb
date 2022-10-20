class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 42

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51f87ecef8a5e4ec2709a35a446c637cad13a265f486bf2ee6e401fd117e5308"
    sha256 cellar: :any,                 arm64_big_sur:  "8293f75f81d7a30159edd0cf1f36c009e13b6ab5b381965fc009694746285a91"
    sha256 cellar: :any,                 monterey:       "f7624395484ebdb8b1c2313bb28c0914dd2cf3bafed69958b868e2dab356adac"
    sha256 cellar: :any,                 big_sur:        "283c78e3999df58ee224deb2ab8c230bbff0dbf3740c2cab99d5a07bf97761df"
    sha256 cellar: :any,                 catalina:       "f0e7a6c067904aab5384c5d944ca011081dced065f35916ccde199f16aecc800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0e6899388068cf5a2697a562ed367a4d7c466df4b2a261a61c6032df0fe7d8"
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
