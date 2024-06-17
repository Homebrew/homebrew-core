class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "cad1d2dfd58f9267580e2de0c9617c312a3ca082d1ce3e5f82aaa54ae5bf9470"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0443dc2c921f821688d5ca1c0632a25918b3ddd69f84395a0a0f4f06783b41a4"
    sha256 cellar: :any,                 arm64_ventura:  "e974448bd850bfafd406da12b2381bd7917ee82d408d608d54380ca95fb88551"
    sha256 cellar: :any,                 arm64_monterey: "29bef16965dafcc00844b266326ad3200f76ba11bbf57977425e5d8d0f0c4d71"
    sha256 cellar: :any,                 sonoma:         "331b7b19259a2a816f76a43d8f568b18a77cc7a9d91a7bc34b6c074e7201cbf6"
    sha256 cellar: :any,                 ventura:        "f721c6b0a631979ed7fb5cf22d3cf3dcf53d2b4e87870ac883918eb00192d410"
    sha256 cellar: :any,                 monterey:       "1cd1c770cd9380cf5f8c3842a898b0ef36d2a4972d9bcf7292020ac03e81ca74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae99e4db91d3f7c56efda9c7a4039fb5a2f1334e229baf4b3ba7612545f3afa"
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
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
