class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.5.tar.gz"
  sha256 "173a42189f0fa447d04d63b27afdd10af9c5035061db00ba1e2b390622b49803"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "882132f6bc368ec5d46d66557b61dde35f49c7d851d43494b342994f50ca2bec" => :sierra
    sha256 "90acf36261eac25b7f287269dae131909befc7cf9be212879d61f3aead1d28e4" => :el_capitan
    sha256 "8911b8f2511404931f87190390d0684c74e32a9580a65bf411bc2a8289d87f4b" => :yosemite
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
