class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "9c516dc0208bd32f4c17eb480f5fdb4dbdf0928d1b8200a855e21de85a337f76"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b8c6414e531eb7dac5e552590ab062dca025768145ac317e04d946c7469ad76"
    sha256 cellar: :any,                 arm64_sequoia: "d8710075ae33409f95faffc1b8a5db9d32a44dd32102eff5c0a36fb1da01c6e3"
    sha256 cellar: :any,                 arm64_sonoma:  "de1ed94695d4ae6a3716442c887ffefdc8b90c5878a980a0eeba437e7ee18fcf"
    sha256 cellar: :any,                 sonoma:        "f994215700df9c01ae56178ab9285625d5294c72aeee12f47d513d13dcf868d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a408d239059927972b748defd8455e016af5f6cd2b98655729fe44a5cb78a763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bff1b202882a58dc19752750fb6d8d20bd39c42948ba0121243dada0fd5727b"
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
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
