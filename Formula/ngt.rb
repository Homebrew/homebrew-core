class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.14.6.tar.gz"
  sha256 "5d7b092855ecea76f6dcf439beeba774a36893aaf7a61732de07068449f6f86f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "396c9824989332a89bbfba2181f3f254b43c7c6200bb54e67650f67c2b0fbf78"
    sha256 cellar: :any,                 arm64_big_sur:  "935d284d92326d4f94e2dbe711649e315c9806fca44f53ffdd0b8e3ac778ec15"
    sha256 cellar: :any,                 monterey:       "95b5ee150031b09d5944456a521f6dd1645409ccf00f1204cd9ee078b8af5b7c"
    sha256 cellar: :any,                 big_sur:        "67ab721ab751f4ee0cace5ee748b8d6c2eda40667b8102ccd623879cf0817b7f"
    sha256 cellar: :any,                 catalina:       "9b1d239e62573e9eddfa500106acc7d90e9154362930b7d1be90c7769a71ed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7492d0e49321729aaf643453315b7cd733f12dae20386aa1d86158638213cb9a"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
