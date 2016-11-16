class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.0.tar.gz"
  sha256 "faa8a8d1c7ceb35b57fa89fd83ca97f4d28e90effbe1450cfe356af28ecd3ef0"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f38ef83e5c1759becbc3092329df9c652997e7b9200ca4753529f8e398de2f40" => :sierra
    sha256 "c764e61dc7f9e2508d9bf7fb5bb2bfa1e0d3c85521f441f9dc0e65447e30a626" => :el_capitan
    sha256 "b36ee719d486ca15850472ed50d523eca256710079e236ac879ff4c700887732" => :yosemite
    sha256 "2b48f64eabd1c4e88c71dc2c45d50fa7a6ba9fa90fc5e620de6baf2555e51ea6" => :mavericks
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
