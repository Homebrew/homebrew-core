class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.9.tar.gz"
  sha256 "61816974ac3e730827b8882a235adbf6d50b9a0af5ae214612b7a79bd02292b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "244539003eb84e06b855b1045ac49c5c5151469aa00296939685be2f35ce719e"
    sha256 cellar: :any,                 arm64_monterey: "bd4207143377a5336d4f080ddc86ba5b9b04de4c986de847b34533288cf8f6c2"
    sha256 cellar: :any,                 arm64_big_sur:  "f481f5c1c16ecc4b3c54828ceef614ad336f10ec877cbb016c46595c9f27439b"
    sha256 cellar: :any,                 ventura:        "a31d8a5b8f4bc84a21487c3e93775ef1674517f4a76f818b23d4a69c85f6cf75"
    sha256 cellar: :any,                 monterey:       "a24f41346a6e71f29ab707018e7f5eff811b3c39b66bee1732f99207cf4370c6"
    sha256 cellar: :any,                 big_sur:        "e6a87cff7a62640f9abb6b64adcec93d314cce32aea4e34ad6a8368a22bbe164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c8dc860c3b8dc59f651c63453070bad70fc441a9355a47df349e653d904135"
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
