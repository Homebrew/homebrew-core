class Libmxnet < Formula
  desc "Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler"
  homepage "https://mxnet.apache.org"
  url "https://github.com/apache/incubator-mxnet.git",
      tag:      "v2.0.0.beta0.rc1",
      revision: "f0ef9d848a661bd2469faed6d0b9c12c10e4edb3"
  license "Apache-2.0"

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "jpeg-turbo"
  depends_on "libomp"
  depends_on "onednn"
  depends_on "opencv"
  depends_on "protobuf"

  def install
    # system "cp", "config/distribution/darwin_cpu.cmake", "config.cmake"
    cp("config/distribution/darwin_cpu.cmake", "config.cmake")
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LOCAL_ONLY=ON", *std_cmake_args
      system "make", "install/local"
    end
  end

  test do
    system "false"
  end
end
