class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.14.tar.gz"
  sha256 "20b32a2009798a58f8540262c25edb67e80ed5db1d0225e79fb630d685a6ee2a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "265b3b3f06fd89bb48f5d67e4731fdfc218700cd3e6ee8e1982d50fc495af71d"
    sha256 cellar: :any,                 arm64_sonoma:  "7ed992451955cef17e3a2eddf6037d42163a7e70a071d2dad494b8c107aae664"
    sha256 cellar: :any,                 arm64_ventura: "bc9ecd106519b74c8771729bc3cff218a32bf0a07e975f1ea4d5429e556048d5"
    sha256 cellar: :any,                 sonoma:        "f49712172e06277b5090433ed1551c5dc6bbaa3bd61db6b5338c5dcd2e6420b6"
    sha256 cellar: :any,                 ventura:       "e7062fc9aa21f6d64ccd6adc2951cb3fd23bbfe477661e85f53d884381808813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4cd23bfd692945caa5780ec0af632ed23f9d70a08e665a76db5cfa0740114da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7929a1a321e3dfc3cef08b9af813c7cc0c9987e4d9b66d180a1d8cfdefbf71ba"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system bin/"ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
