class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.11.0.tar.gz"
  sha256 "3f63aa5dfaab861360fd6f9548aa7f552b007cac7e90c99089d3bb4bb4b9d451"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19e9be0102403bec2475a4ec9b6111a30084e88a2ec55b5f2b89a9f7ea9e0bd8"
    sha256 cellar: :any,                 arm64_big_sur:  "2b212cc37bb6c8162328c139ebbe13c799d011996ab53d37c524d7812aabfbbd"
    sha256 cellar: :any,                 monterey:       "39c4040aafb4d4e4423c218e84fdff4bc8fe8cdb4403ed37be3434f159b08078"
    sha256 cellar: :any,                 big_sur:        "0cb00c7f93c032c997e1fb478195cd2192d2717ecc975dec77ac2f5d21b2ce15"
    sha256 cellar: :any,                 catalina:       "d95cab709c7a899bd66b2fd7603bfba20ce337d436433d9e0b6d45485b806e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a615d38f5b721d5643eba7bd02c9ffd88803b424cecb20d418c8bd7b00a6cc2"
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
