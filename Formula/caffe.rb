class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"
  revision 2

  bottle do
    sha256 "82daa7416902f8a56007eff36a80d970dac59c46a2b5323def706872cce2c90a" => :high_sierra
    sha256 "9d325092d5f966659075a6691a63f7855ad1ec224e51486975be95fe2ccfbde3" => :sierra
    sha256 "10256bada9b29f704bfdd881284b5862583bd3a99c168a2cc267f1920d1344bb" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "hdf5"
  depends_on "protobuf"
  depends_on "szip"
  depends_on "leveldb" => :optional
  depends_on "lmdb" => :optional
  depends_on "opencv" => :optional
  depends_on "snappy" if build.with?("leveldb")

  resource "test_model_weights" do
    url "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel"
    sha256 "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DCPU_ONLY=ON
      -DUSE_NCCL=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_python=OFF
      -DBUILD_matlab=OFF
      -DBUILD_docs=OFF
      -DBUILD_python_layer=OFF
      -DALLOW_LMDB_NOLOCK=OFF
      -DUSE_OPENMP=OFF
    ]
    args << "-DUSE_OPENCV=" + (build.with?("opencv") ? "ON" : "OFF")
    args << "-DUSE_LMDB=" + (build.with?("lmdb") ? "ON" : "OFF")
    args << "-DUSE_LEVELDB=" + (build.with?("leveldb") ? "ON" : "OFF")

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
