class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "1a80d7fbd2b3a2684049afe61407d2276f6faf1dd1ca3f886cdb07c170c08e65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2db17fe4a7e4faf7b848fe8be9bedb05dccafe6202d574c159f9d43de9aa2f78"
    sha256 cellar: :any,                 arm64_ventura:  "110dd79c63c3b612b446f5dbb149301581867a4c0b8024bf4894cc2fce2cd5c5"
    sha256 cellar: :any,                 arm64_monterey: "815c9a37762eb15788c8e7ad6b7da86a0ff63c9137967b07876d6ea313621982"
    sha256 cellar: :any,                 sonoma:         "69351321bb32aa67da12b70e438c1bbacdc02e516f01610a07df1c89739d285a"
    sha256 cellar: :any,                 ventura:        "64a1e1d62f824b8015843d52de8272eae02a696c10f8d2f7dac18fd815ba8244"
    sha256 cellar: :any,                 monterey:       "28da9e121ab022105b61f776be0c002853c0e170c60f3991dc65d90b8db3eb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8ecc133a5f941cd3b84ee0d2d124d3fb628e595ccbd9a9ecfc4046adaec920"
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
