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
    sha256 cellar: :any,                 arm64_sonoma:   "e2b7df163de75c2d1ffc03a2a3cd8a458fc7108e01b6dfcefbdc6517302cd191"
    sha256 cellar: :any,                 arm64_ventura:  "45ae58e3412cadde15bc46e89225b9b259b44e81f5c0304aa9490872feec5790"
    sha256 cellar: :any,                 arm64_monterey: "218cd81826671227870bb65317bb42d9b7b1742103582f42e30b9b365b7932b6"
    sha256 cellar: :any,                 sonoma:         "30d97d287876702216d97d59e32a3df21c1586134458be069ff52aea48253e02"
    sha256 cellar: :any,                 ventura:        "9df9faaab88d83c002dc0c0733ce4e61d100a40abf72f0f94ce3e03162b09de1"
    sha256 cellar: :any,                 monterey:       "009315fcc87bd9b85391c3d94d4716b9da8dd1b0f2e88b0b8c34a7a8600bd337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf856497d4397a8c46c27d44cbf37fe675f031e25aed4ca43e10d386a2e7fde5"
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
