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
    sha256 cellar: :any,                 arm64_ventura:  "851025124ffa9a6ab3c2c5648235b670223263db6e51cc75d6637c3a6cca9dad"
    sha256 cellar: :any,                 arm64_monterey: "9759eb95755587a0387fbc960524a3b51750b41112e9c436ee310f3c44475c68"
    sha256 cellar: :any,                 arm64_big_sur:  "fe030feb0380c4552b267755aac189428f9530c6dc2df197caccced5d1ec9a34"
    sha256 cellar: :any,                 ventura:        "21397e4aaa43353be2ac91b360566801b68aafad50ea43afa8dc3dc821b2ad69"
    sha256 cellar: :any,                 monterey:       "90169470d1fcd5414b2aa36b2f8f63957636bff6d47666ed2389dfca2b806e50"
    sha256 cellar: :any,                 big_sur:        "ed74360e239d0d9d9d9ef8b701965462113da6df0e3dfe990f80f4e565c71f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f070b4de9e6027dc8ca3f5aa341e99f57dfecf6e11fc32842a74f1d1a79d3c47"
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
