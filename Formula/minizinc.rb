class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.0.tar.gz"
  sha256 "faa8a8d1c7ceb35b57fa89fd83ca97f4d28e90effbe1450cfe356af28ecd3ef0"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "003a5053731e29535d67d7d8d410397bd3ee88505831e75fe7b44e419ec84a76" => :sierra
    sha256 "58505769b8b219c4281907f7438fc5c84d363db12d1200583e853e129898b65c" => :el_capitan
    sha256 "cdc5391b46ac64d4288b468a47a9bc97fe293707c973909f05fe74004bc92fee" => :yosemite
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
