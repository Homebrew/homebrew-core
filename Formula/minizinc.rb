class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.1.tar.gz"
  sha256 "d304f5d7ef6f95357a44371d9499c29a01808701b47db73d8236c568e2a1a18a"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b64c8130879d31d4bc2b29cd0c09f4382b9139b198e4017636f5b0ad842b1a0" => :sierra
    sha256 "f894cbc805eefa5edd0e4f768a5a6b1750a283c9580ad081d04e0bd7b38adfb4" => :el_capitan
    sha256 "f3e07be07e07ef6acba223eacfd79ab177874639afe0ccda515071de24b06c3f" => :yosemite
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
