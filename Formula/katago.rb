class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.4.1.tar.gz"
  sha256 "b408086c7c973ddc6144e16156907556ae5f42921b9f29dc13e6909a9e9a4787"
  revision 1

  bottle do
    cellar :any
    sha256 "74b33afb60945ce4660e74d9f2cc93624fc7c34339dd08ff0452755b0550fc3c" => :catalina
    sha256 "d4ebb68a0dd14bd3e758ae076f758357b5e1e13774e40b4025f4fbe4ea6b6e38" => :mojave
    sha256 "6d161c4cfe4821b3d0e3550d475f55ceb74916bc8b1e7fb93e8074270df8ea2b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libzip"

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b20c256x2-s4384473088-d968438914.bin.gz", :using => :nounzip
    sha256 "da070fddb45e4d798a63b0be1960d604ad422690d82ac66b1d4ee41e8bf42536"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b30c320x2-s3530176512-d968463914.bin.gz", :using => :nounzip
    sha256 "67bd8f67a0ed251d78626ccd23cd4cdbcc880ffc29b641f65cf79ec9d9be83e5"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.0/g170-b40c256x2-s3708042240-d967973220.bin.gz", :using => :nounzip
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
