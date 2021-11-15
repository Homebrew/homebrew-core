class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.10.0.tar.gz"
  sha256 "2d9b3fced61df90953dfc92f689ceb3fefba65b816388fe42bddad5c0d68bda5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f9bb858293b8c8d0582b19cd271ed9156cf4593e592355d274194ae515c2d03"
    sha256 cellar: :any,                 arm64_big_sur:  "b0d8098bff82d54688f0a8ee1737f1c47e9386ed14fe4e81e57d2cc54be78da5"
    sha256 cellar: :any,                 monterey:       "9b7a51623e9313186c883e52da686d4608ecc8337132b0669b3df55982e881b4"
    sha256 cellar: :any,                 big_sur:        "2ac6080f0d70def750f21e312a0bb2d7c04d3d610b18d556be65743448cdc244"
    sha256 cellar: :any,                 catalina:       "5432c54db74beecb6ecffca6fe15d76d2d6fe357ebabc024144aaaa2d10e5818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29de134f9ba84efc70589b1a1c93571ebc5b1ef3b9c963f7fbc0b784d889537e"
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
