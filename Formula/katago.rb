class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.3.3.tar.gz"
  sha256 "de346ea2e0e58f584df482c4ba28703d961dbdb6569bc4203d3edb98ca6c0b1a"

  bottle do
    cellar :any
    sha256 "c17f6107f9ea75ccb2f329e8e6a230d58bfe1d20f3ef931b7c5a5449b30df170" => :catalina
    sha256 "5c24c0330a7f341024359f23ecc0c82c7efddae75b4ad9478c7615af34a5363f" => :mojave
    sha256 "adeba8185fd536f7394e94686e5721209df8140a6e6784ad71171bc26221e3da" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libzip"

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3/g170e-b20c256x2-s2430231552-d525879064.bin.gz", :using => :nounzip
    sha256 "770f65c5cfa6e7ebba1b972768406668afdfc2e65d61e45b8cb468677f5fea4d"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3/g170-b30c320x2-s1287828224-d525929064.bin.gz", :using => :nounzip
    sha256 "3c2864fda18d8bc595b1fb65ec25cc998ac90cd203a6269c56691e195297c325"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3/g170-b40c256x2-s1349368064-d524332537.bin.gz", :using => :nounzip
    sha256 "74ea1a4e9c0a461b9fb35a297d11f10e3fcfee32e5b710720784120fe52cbad0"
  end

  def install
    cd "cpp" do
      system "cmake", ".", "-DBUILD_MCTS=1", "-DUSE_BACKEND=OPENCL", "-DNO_GIT_REVISION=1", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
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
    assert_match /All tests passed$/, shell_output("#{bin}/katago runtests").strip
  end
end
