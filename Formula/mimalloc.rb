class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  # 2.x series is in beta and shouldn't be upgraded to until it's stable
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b1912e354565a4b698410f7583c0f83934a6dbb3ade54ab7ddcb1569320936bd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8b04769cce9dc72da71bc7ea8709ab7892f9f6f224cdc079a4c810fe1530063"
    sha256 cellar: :any,                 arm64_big_sur:  "d58eb09178145c160f13902a84cbfb555c814c764d89b03a96294ed2ff4e1375"
    sha256 cellar: :any,                 monterey:       "d2609eff9603a69d8a111a83aeebd47c9c3093b28d100f3e3a1a2d391b0c91d1"
    sha256 cellar: :any,                 big_sur:        "d9a90d0801403374429de0014eb0a8ce54c943bd933184a02a90312eef9fbcfa"
    sha256 cellar: :any,                 catalina:       "f3a16ec9db7143ff17d0dafba31f952f71299fd3cf121229962f901aeb6a348b"
    sha256 cellar: :any,                 mojave:         "1b8ccb7e87846a9625645a9c6f6fb20ff3812eb28b9dc3f35607be223c16a21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52e4812137cb1272b5887a554eaea818ed04bbcb69da2c49a8d2402df02fdcf"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMI_INSTALL_TOPLEVEL=ON"
      system "make"
      system "make", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
