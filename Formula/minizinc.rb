class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.7.tar.gz"
  sha256 "e59075bbdcc36821d757b3b3fff288f341a0d30ce63dc253cc26ade55292657d"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "970176e584ec4e246b2e2435e14f95037a2a3d9f607c6ff29d6e024ba5371e8a" => :high_sierra
    sha256 "d4d6ce59e834a8c3429ae4d1ce46063148d7c07b9fc02aa30d4cb8b27d2cf469" => :sierra
    sha256 "d76a0ec9eac191b1aee519540dcff60a40400099f5c1a3b0fbf5880340c5bc5e" => :el_capitan
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
