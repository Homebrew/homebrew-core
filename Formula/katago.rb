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

  resource "15b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.2/g170e-b15c192-s1672170752-d466197061.txt.gz", :using => :nounzip
    sha256 "09456899f1b9155217f4ca059cf8a68f79b7eba22cf6b7c00ffb7f17ce067967"
  end

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.2/g170-b20c256x2-s1913382912-d435450331.txt.gz", :using => :nounzip
    sha256 "c309c0361ca1109084dd026235c9fa0254ffe22eecf096b6c5988a9d902a75ca"
  end

  def install
    cd "cpp" do
      system "cmake", ".", "-DBUILD_MCTS=1", "-DUSE_BACKEND=OPENCL", "-DNO_GIT_REVISION=1", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make"
      bin.install "katago"
      pkgshare.install "configs"
    end
    pkgshare.install resource("15b-network")
    pkgshare.install resource("20b-network")
  end

  test do
    system "#{bin}/katago", "version"
    assert_match /All tests passed$/, shell_output("#{bin}/katago runtests").strip
  end
end
