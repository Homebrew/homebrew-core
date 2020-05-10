class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.4.0.tar.gz"
  sha256 "587bb9b108155332a0b3191c5293bdb6e6c6348193a44bbb883dd9a9bc0bb925"

  bottle do
    cellar :any
    sha256 "3ec9bc71c7582ea9b02762b01a6f2efcd93fe16a25fcaa4e1cef01323cc6da75" => :catalina
    sha256 "cdb08d3ef47abb440cf6b01cf30897825d14d7c644cd57efa26406070a0ddae1" => :mojave
    sha256 "0509f19c581105d01a756341901add9126c3c16259248d843a0d21a8761536c9" => :high_sierra
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
