class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.13.tar.gz"
  sha256 "716e83eb0ecccd344b1e3ebafe5fe2011f4f93d06ae35d15c6a17cfc0a5d561e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c393e91a75444ad2c09890b26fcba2a008b00c18d99030d174c5fbaca8fdc39e"
    sha256 cellar: :any,                 arm64_monterey: "d8d2b205fcdf4adfaa75dce6c6b32b4b4ce056e8532cfbba5e9000773767c4fe"
    sha256 cellar: :any,                 arm64_big_sur:  "2b0215b301e5497811fd340d5e5821f8ed94e45b83c6ecccee9ecadc5b5322c8"
    sha256 cellar: :any,                 ventura:        "ab1eef41a9b71e240e1cd1eb589495827a41b0ccacc664fb4cf5fad224540810"
    sha256 cellar: :any,                 monterey:       "fcf025311bfd03d5d8056e4e5cd40538fb368023b0d889d3ef74b3c29743db58"
    sha256 cellar: :any,                 big_sur:        "680f623f701491e31d25420ea0c26f41317dd3741b6a0694a0f856e8e1afc84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035f24d48d5410a67a77fc6be04a0a3278c52be825882e14fbee037eb017233b"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
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
