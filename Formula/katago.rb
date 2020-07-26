class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.4.5.tar.gz"
  sha256 "6d29ed8acb45bc4b1b0f39a9a3212f94708d3e2770642aefc3e3dfcf332e8c78"
  license "MIT"

  bottle do
    cellar :any
    sha256 "c45535348f0a10f88414dc1e99e43b4c6e62534a790d2deb0422ecc52178eb9f" => :catalina
    sha256 "813b95e5bd6e1e1828e4624daab8ef63fdb3f610fda611b5f6406c3d7e44d78d" => :mojave
    sha256 "8fbf9ccd531dcc1ba21b01259a50f3c11de9dc586e80191637b903ab598143b5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libzip"

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b20c256x2-s4384473088-d968438914.bin.gz", using: :nounzip
    sha256 "da070fddb45e4d798a63b0be1960d604ad422690d82ac66b1d4ee41e8bf42536"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b30c320x2-s3530176512-d968463914.bin.gz", using: :nounzip
    sha256 "67bd8f67a0ed251d78626ccd23cd4cdbcc880ffc29b641f65cf79ec9d9be83e5"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b40c256x2-s3708042240-d967973220.bin.gz", using: :nounzip
    sha256 "9053c1f0f7834533b34556d3454fe0de8736d5951a2fe5d02c3aebd3fc20240e"
  end

  def install
    cd "cpp" do
      system "cmake", ".", "-DBUILD_MCTS=1", "-DUSE_BACKEND=OPENCL", "-DNO_GIT_REVISION=1",
                           "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make"
      bin.install "katago"
      pkgshare.install "configs"
    end
    pkgshare.install resource("20b-network")
    pkgshare.install resource("30b-network")
    pkgshare.install resource("40b-network")
  end

  test do
    system "#{bin}/katago", "version"
    assert_match /All tests passed$/, shell_output("#{bin}/katago runtests").strip
  end
end
