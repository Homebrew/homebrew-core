class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.4.tar.gz"
  sha256 "bdda52c97060a7e1c200dc46949bb01c7abb8af469639c691601aa97bd9eb717"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2feda997c2184c5d0b630587044c4e1cec9ce3f18e6f37438bead5782a00577" => :sierra
    sha256 "0f3f0463bf53e561ee2a9c6952b92fa6d676747c75e6e7ee4e6842c2878b2001" => :el_capitan
    sha256 "b90365bdb6f85187adf632025689ca798b2ac62b651908532f8361a1e34ee289" => :yosemite
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
