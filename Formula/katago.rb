class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.8.2.tar.gz"
  sha256 "4a3ae33debb220d3bbfe302bdf8689ea82f1236fe3d2c8b2ec91d407bc0bac67"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5fc123b94df821249122066d22b08bcb02e348f6e06ba48bbf20321a0c1147ad"
    sha256 cellar: :any, big_sur:       "07abc11306ee69be6c355dff24d7ef8bd2b202657f69693ace8ead9c89afc8f1"
    sha256 cellar: :any, catalina:      "9c0cf564eec57012ff01bd4a0b95d933e4430ddf6adf7b4cf04b5aea748f0b6a"
    sha256 cellar: :any, mojave:        "3fa5d13812dd6aa7f3358fd250125f3b2a06df2ee609a1cdf52b5d1164e3a400"
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
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
