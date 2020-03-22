class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.3.3.tar.gz"
  sha256 "de346ea2e0e58f584df482c4ba28703d961dbdb6569bc4203d3edb98ca6c0b1a"
  revision 1

  bottle do
    cellar :any
    sha256 "62bb0b8e190b713c707486100f848335e44346f5b0e013d1de695fb1257cce32" => :catalina
    sha256 "94f018ae0a9c3d384d69999039f447bf5533f1623ad4e4e0024e6ea1fda6bf20" => :mojave
    sha256 "62999f2863e2d05b9c975dacfe7c8653eb828b0120861abb93a4d857a3a5c787" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libzip"

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3-nets/g170e-b20c256x2-s2971705856-d633407024.bin.gz", :using => :nounzip
    sha256 "dba074142b9da4822ed9ad91c676372fd943c0c115b7975773dd292b9e96a899"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3-nets/g170-b30c320x2-s1840604672-d633482024.bin.gz", :using => :nounzip
    sha256 "2f066112e163de396f5bd56b94162419f16ff48e9fb9836c35a711122ecc9a32"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.3-nets/g170-b40c256x2-s1929311744-d633132024.bin.gz", :using => :nounzip
    sha256 "acbdd1aa883d7d8d60101cdcd0c75754ec25dba66b4d60d8d284427cf645124d"
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
    assert_match /All tests passed$/, shell_output("#{bin}/katago runtests").strip
  end
end
