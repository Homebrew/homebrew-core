class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.14.2.tar.gz"
  sha256 "3921c6f170798fb152077689513d10b603d91540e3f5d07f5435afb7b96f88e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3ff1994baec3cdbd93629c55fdb845d81183aaef04f4f6907279e971f92a0216"
    sha256 cellar: :any,                 arm64_big_sur:  "17935d6f93036acc9c2075e5e8ca648519610e2c5ffd67fc1b9a2fcadaa36a21"
    sha256 cellar: :any,                 monterey:       "8dd1daa419c8e77966807ffda9fd4de781dba35ea1aad1566d0b83f0d8145628"
    sha256 cellar: :any,                 big_sur:        "507100b0f640aeff2016fc2f2dd0472d72583e6bc29c88f5beb986c21604cfea"
    sha256 cellar: :any,                 catalina:       "89c5bab2de745a7b2b448cdee35b7d095eaa48d2409cfa75cef32b75b7aee800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b28c3b33efca116dfff5997aee40ee84185f2f985bc63f76537c69a831376bfb"
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
