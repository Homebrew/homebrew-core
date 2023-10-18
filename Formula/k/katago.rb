class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.13.2.tar.gz"
  sha256 "f1a5659ff6dcec246f11bd250dcb41f1879dbbd41d4e909ae030954acfebde41"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66ad7cd538016f47d077627bf9cd4db9ba362cef88a4fa6304501e34d6f059e0"
    sha256 cellar: :any,                 arm64_ventura:  "24d76ed00bbf64d167a83c12001ac835b65103c5e85b6ebf8a5b93e5a8bf3512"
    sha256 cellar: :any,                 arm64_monterey: "2db7357727a48db58e70fe62264a800144a511c9ec4aef38f85a81c804937eb6"
    sha256 cellar: :any,                 arm64_big_sur:  "f011b1579df3f2a73501a0b1d6888d2e97f0a9e50582715a653a208ad8c79ecf"
    sha256 cellar: :any,                 sonoma:         "e5dcd05b32cb92128568665459ef926a43937979dc3fe0a0b57621ffce118ce5"
    sha256 cellar: :any,                 ventura:        "31d20fb5161a16e7c114674c1c1045195bd7b5e632fb46b079d98af3f86b6597"
    sha256 cellar: :any,                 monterey:       "483f40c2adc32e78206f3b013db29e07e6d019f2f49d10f01473f4c870c03adb"
    sha256 cellar: :any,                 big_sur:        "1a3b82f3237a766a84238b4d7c3bf4b3fa43fdbfe84fd6c805231cb477dab377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722843df08f4988959d58447af7f899580caf952883a7db029107cee349d932a"
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
