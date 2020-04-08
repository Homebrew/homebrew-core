class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  revision 19

  bottle do
    rebuild 1
    sha256 "1214d7d099e17a5b2ab1ce69aa8d815db425a6265801a85b020915c78689e18a" => :catalina
    sha256 "8b20b9407cf8c059010147e546c678f01054fad149ba59bec7b4c6971848e46c" => :mojave
    sha256 "29dadd9fff6f1022a2bd3990f0c5325c83dc937a7d508af1051e390d8872beb5" => :high_sierra
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
    url "https://bintray.com/homebrew/mirror/download_file?file_path=bvlc_reference_caffenet.caffemodel"
    sha256 "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0"
  end

  # Fix compilation with OpenCV 4
  # https://github.com/BVLC/caffe/issues/6652
  patch do
    url "https://github.com/BVLC/caffe/pull/6638.diff?full_index=1"
    sha256 "6a6368d715284fabfa96660b6d24d1f4f419f3e6cdddab9a7293954fee4ec2bc"
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
