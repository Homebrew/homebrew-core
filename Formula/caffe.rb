class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  license "BSD-2-Clause"
  revision 30

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "77cac15d97693c487ff5801fe65f582ce4743473615fac2898ce911825b4884a" => :big_sur
    sha256 "e4b558168ef2449d63356e5ac0cba1935a750784baa5fa28bea480b5b236fc0b" => :catalina
    sha256 "b8248cea3d0bb1840d3df53439db7a8f08bc67dea7e1a1f00a7500ff57a68074" => :mojave
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
