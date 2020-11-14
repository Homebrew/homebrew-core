class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.2.tar.gz"
  sha256 "35e3d1bb3ddafa01c6b06f01d35df5bb11d3de9f11101ac28aa68cc6d9da594e"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "498490c7e642c12faa284025b869c412472458646e24e0cf80ff86f8c009bf6f" => :catalina
    sha256 "ea4958bcc3b0e8a47817481e03dda148c301416ed1b6ff018963adfe899224f2" => :mojave
    sha256 "0825445b5daea818ed68f4669134e17919029ba40cefeda5c070ca18697f13e4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", pkgshare/"std/all_different.mzn"
  end
end
