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
    sha256 cellar: :any, arm64_big_sur: "c7f4a9c7a1119ce686f0d4c1337ae356a04c149599c6fa0dc4a98a1e3f4f8c44"
    sha256 cellar: :any, big_sur:       "71df6d084a4d4cc69024f1c3260c41b78af143062872c314f21aecd7f95ac07d"
    sha256 cellar: :any, catalina:      "127743274a8220c01f082604735482020a35dba8ebfc6cd08a32372e319df1e6"
    sha256 cellar: :any, mojave:        "02d52576abd5791ec271e0ab271de9889302a12800947041b37c18465ff15af6"
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
