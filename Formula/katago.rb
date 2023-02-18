class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.12.4.tar.gz"
  sha256 "dfcc617fa4648592fecd0595dea9b90187a2c0676bdfc11e8060fc05ca350e47"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c411e717d6abc03bdba42fc59e41ab8d39df74698c0b2b3738f9f2b6fe3c3e26"
    sha256 cellar: :any,                 arm64_monterey: "f4327c496eed90ff3fcedf7bd31f10dd3aea17e74035be297672c0caf6063d2a"
    sha256 cellar: :any,                 arm64_big_sur:  "703e95fed63ca4673d52e8b193844787ded4f4df13bbf6281b0499583c4b6aa3"
    sha256 cellar: :any,                 ventura:        "7b53b154ac37c80c7cf81e1d25e34e30d5438f1d91faa698e66c1abbc334cc1b"
    sha256 cellar: :any,                 monterey:       "361821c12fb2f598c5a5c7c3feea63658a4a4fc4c585eb9f26bdb51e076c0ea9"
    sha256 cellar: :any,                 big_sur:        "3290fd5c2764a724de19c78e575280fffcaac8ea9ee09470be7774d160bc2c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cdbe6ef771685909f9db13e3befd441f2a1592e0dbc4ef97b6e46ed5c170a5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libzip"
  depends_on macos: :mojave

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b30c320x2-s4824661760-d1229536699.bin.gz", using: :nounzip
    sha256 "1e601446c870228932d44c8ad25fd527cb7dbf0cf13c3536f5c37cff1993fee6"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"
  end

  def install
    cd "cpp" do
      args = %w[-DBUILD_MCTS=1 -DNO_GIT_REVISION=1]
      if OS.mac?
        args << "-DUSE_BACKEND=OPENCL"
        args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
      end
      system "cmake", ".", *args, *std_cmake_args
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
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
