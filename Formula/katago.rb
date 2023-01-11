class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.12.2.tar.gz"
  sha256 "d7c723e6f78b983f0d8d221d06b445534020845093921f3ef53d31a6d96345ec"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b35950ec0e8986fa7a12b62ac45bb6cf1dc004ec0734b891cf9952177aa52cee"
    sha256 cellar: :any,                 arm64_monterey: "fed89c64aa24e1f82655c0bc6b3e4bed7e8b51f92e70f9cb5f12e9fd9d018b60"
    sha256 cellar: :any,                 arm64_big_sur:  "ac6d9ce33fa8dfd390874d2a33a530d11c5fa792acc60038a04bb41b05676ecf"
    sha256 cellar: :any,                 ventura:        "430b6ea7e436bb3bc92d927067b74991742af054cf1507bbbe7dda5be8da1f51"
    sha256 cellar: :any,                 monterey:       "578ca8f38c35ee7f16cfa27050bb10bc8fc3a34186b4a64d349b3c258bd3f7c7"
    sha256 cellar: :any,                 big_sur:        "05343e6ab0bb1443a2336eb644c991063cd61f3d9cfa46d3c19dd17914286103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dee5cdfd5d8169082172196cf0d5bdfd8f08d54bb82251d67b4a684aa77b6d"
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
