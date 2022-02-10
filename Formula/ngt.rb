class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.8.tar.gz"
  sha256 "cfb3225e88c414de77291927469659cef307fb6daa739cc8fe6465b578a1c5b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "968983e99efc3cdfa001fc1fa1161b3f09e2419aad21a91ebf79b904bf03f58b"
    sha256 cellar: :any,                 arm64_big_sur:  "67fa76c4027aa2548922dc4140228b16346f0fbe5617d0a2b869a5821eb31861"
    sha256 cellar: :any,                 monterey:       "a9ce2d0cacad0fdb60f2fcfabaedb36a16a35d06fa82764347d1c387fa396c3b"
    sha256 cellar: :any,                 big_sur:        "fa20b9591884fdc440456c0a7d7fb20ce33158e2f1f16616250f088fc3e5bee1"
    sha256 cellar: :any,                 catalina:       "9b270ea591965761c45be1eba6df4b1f8430686ffc952c817db0a384d936e46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26af5c4990877184da91b5de1090af603fa2bca8b67bc0dd6e56297d507b740"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
