class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.1.3.tar.gz"
  sha256 "fbbaa7ce5d175eba22e443f008869a4ee080d63be4e49fd7d42b2ef3451252d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef9674ebcf889b50fdf21414e40145db3dc186468dc6f1148a2fa97e5858d028"
    sha256 cellar: :any,                 arm64_monterey: "eb772e743d3ca74effc7b3aa5fb868cf7e8f3e3ac8b5a52ec9a08d018dc44636"
    sha256 cellar: :any,                 arm64_big_sur:  "58e4088a31bc89b6f4097dd5b63b68029197ec1810bc6c9b2e441ae5c8f07396"
    sha256 cellar: :any,                 ventura:        "dafad91da026c63d8f2601afebf61728413a1df5c10132267c2f5b8fe0a5ac4f"
    sha256 cellar: :any,                 monterey:       "b7184f19cb2ec2132fcb057a2ac9f718a00ea7c23606623fe8291366171ddcac"
    sha256 cellar: :any,                 big_sur:        "25159f292b647b0ff44454b0468fdb03a165f065b3110f4b111eabbfdf9a1250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eceaa458d3f6e6c650850a382f5b3ab637f243132e63c5830d3b101938a08c11"
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
