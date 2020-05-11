class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/v1.4.1.tar.gz"
  sha256 "b408086c7c973ddc6144e16156907556ae5f42921b9f29dc13e6909a9e9a4787"

  bottle do
    cellar :any
    sha256 "fe1035d581be182ab55c56ad3c050337fbf4b927247961b4f0d7ebdd1ad4497c" => :catalina
    sha256 "a6d9fb791b06d41fd8165de82042eff9e1ba934c9298ba5b8c0a708292ce12fa" => :mojave
    sha256 "a4c3f511abc484b8084d1ca9ae55d2e31e5f06b33b00b8ea187083798f996966" => :high_sierra
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
