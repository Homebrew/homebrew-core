class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.3.5.tar.gz"
  sha256 "0e4cc52a82bf708567d592db07f17e1866eb8146381fc2904ebf075115d91ef8"

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
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.4/g170e-b20c256x2-s3354994176-d716845198.bin.gz", :using => :nounzip
    sha256 "fa73912ad2fc84940e5b9edc78a3ef2d775ed18f3c9a735f4051c378b7526d6e"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.4/g170-b30c320x2-s2271129088-d716970897.bin.gz", :using => :nounzip
    sha256 "16a907dca44709d69c64f738c9cce727c91406d10aea212631db30da66bef98a"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.3.4/g170-b40c256x2-s2383550464-d716628997.bin.gz", :using => :nounzip
    sha256 "08721ba6daef132f12255535352c6b15bcc51c56f48761ddfefcd522ec47a3f2"
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
