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
    sha256 cellar: :any,                 arm64_ventura:  "545a3de01f45b3d6dbc7499e7d2d238ee5c272cf684ac3608d71838c3312676c"
    sha256 cellar: :any,                 arm64_monterey: "5fad67fa83aee0041784d42466da6cf6fad401ca5a6f7e9fc5507340e37096dc"
    sha256 cellar: :any,                 arm64_big_sur:  "6ea44e174155a9f34f246b72f4164e30bee5691bba51613719fedc1f87e490da"
    sha256 cellar: :any,                 ventura:        "51fb52b28ec6e0047ccbc07d0e450ad28b4eb8d4656a6f41e6eac8fd8101fe3e"
    sha256 cellar: :any,                 monterey:       "5eafd8108833693bf7934f7c811c5f8b0ed4eb6629a027d6dff0b08f3b27392d"
    sha256 cellar: :any,                 big_sur:        "195d86dfd85d67dd4e608920d0d80fe048fa6ee985083bf6a851ee131227f973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe65fc80139d97f4304fde188b30a8725b5419bfc0f6f1ef63dd38fa4f7623ed"
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
