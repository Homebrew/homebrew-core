class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.5.tar.gz"
  sha256 "73adada23380317f0cad8cc11325036232551eefa228e1816f62f527bd599665"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "a8afc60cb99ba0d670e544ffd24fda92f2154bb7075b8ed2b994de17ca5a5293"
    sha256 cellar: :any,                 big_sur:       "97c08cfd1f04afd27b09bde575124c5a60b19e6057ccb07f26ea3f4f4f85f3a6"
    sha256 cellar: :any,                 catalina:      "6d4de1454b7aaad5c8eb14420039fcc974a82fcd970f1bb92e07ad90b26ecef1"
    sha256 cellar: :any,                 mojave:        "96650e0eea4d200761d8fc239c47fa04a6f20b6237896fd2fa014ddcb16fb5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292dde44ae3ca838e1e37f6787add85d9cb4ea66872b1ea425b2e789eeefa8f1"
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
