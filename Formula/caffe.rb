class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 33

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3d767a5dba752ede439b5b4fc95990f5d653f94018a9b752d191ef1fd059f362"
    sha256               big_sur:       "58a682468d529c145ae91d0aeca02ae845a135ba8131b44f2af793dd5f470b3a"
    sha256               catalina:      "b39d7b5b0ee21a1c669383643093bcb9607def6d5d5748ab967e2e4d5a931cc1"
    sha256               mojave:        "9f97632b96b5db4fa23d9d8325a69bb078dfad6a44df045416a0031131a95851"
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

  resource "test_model_weights" do
    url "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel"
    sha256 "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0"
  end

  # Fix compilation with OpenCV 4
  # https://github.com/BVLC/caffe/issues/6652
  patch do
    url "https://github.com/BVLC/caffe/commit/0a04cc2ccd37ba36843c18fea2d5cbae6e7dd2b5.patch?full_index=1"
    sha256 "f79349200c46fc1228ab1e1c135a389a6d0c709024ab98700017f5f66b373b39"
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
    model = "bvlc_reference_caffenet"
    m_path = "#{pkgshare}/models/#{model}"
    resource("test_model_weights").stage do
      system "#{bin}/caffe", "test",
             "-model", "#{m_path}/deploy.prototxt",
             "-solver", "#{m_path}/solver.prototxt",
             "-weights", "#{model}.caffemodel"
    end
  end
end
