class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.3.tar.gz"
  sha256 "07982723009fcb50ae190bf17277e8c91e6279f319521f571d253ba27e2c2b1b"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc59b11093d3299a92651e1566e887b319aae45a708da357dea69d39a5c25ebc" => :big_sur
    sha256 "683b363ecf631103f0cdb4989145a2d6cc85ea14d6d947ee2cde6250fe3682be" => :catalina
    sha256 "c2d573adbd73997805b3c4d857292037255a7b7deb923c238320a7c766cfff8d" => :mojave
    sha256 "d76fa3408acce79f7f184cf1e9153dd1f5961b29a43876cb3031d638aa435f89" => :high_sierra
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
