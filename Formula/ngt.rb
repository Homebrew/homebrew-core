class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.8.tar.gz"
  sha256 "04a4c8b06bdc55e90d03256efe62f7cb886b2b08d3f5d001a73e2a53cddad0da"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b254fed7c64f43d084675fd88d4c800ee2ab6b0b3f5b5d1a230333c3b49cc39"
    sha256 cellar: :any,                 arm64_monterey: "054757216892d33386cb4779b16cb4299bb12c3b2c8e6fd9c86f01092305bc2f"
    sha256 cellar: :any,                 arm64_big_sur:  "3c048a10d3359ee0bd5e3d7404751187923cb39a3b7d23e14b547163d59386fb"
    sha256 cellar: :any,                 ventura:        "e080ed818e1ce7d4570343db9e51e7896a67ae488002ff35c8f517c5a531eec9"
    sha256 cellar: :any,                 monterey:       "94a83da8daa60f4ae3a47de5be629fc78c4821d9c4d8268b64f4101c98b9af40"
    sha256 cellar: :any,                 big_sur:        "e484b8271a8b02d2bf71c9d34d63b0461fc66c3212847adcdaa73a77c2946634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538d70407aa77a78ad24a74306fc256c4bef7ef4a621d7f443f6e311b8e30c82"
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
