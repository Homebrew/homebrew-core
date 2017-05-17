class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.5.tar.gz"
  sha256 "173a42189f0fa447d04d63b27afdd10af9c5035061db00ba1e2b390622b49803"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c16ee4f5ca95bd1d3b12f58435de93217a025c35ad27863ea8b188f7998d1a3" => :sierra
    sha256 "2324b9b87ea85f23d090e6cf458ec3514f325679f8fe8cdc404aaabe33ceeaca" => :el_capitan
    sha256 "649f7e18aa98307d3f58864f7305e199c3b094c7b8b7d9b44a08c522c26f9647" => :yosemite
  end

  depends_on :arch => :x86_64
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end
