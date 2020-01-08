class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2a8ac9341661cefa1221418aa2cb5cdd5207108ade6803ab5af34ca01d0aef13" => :catalina
    sha256 "008db46fed420d7ec698d46e059a4913368af4d8f0b2f4f8502a39ee392b830d" => :mojave
    sha256 "f4241a70db520e24c587649bf7b8db0f743afaf00b01ebee5934bee7e88ae42e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      int main() {
        println("Hello World");
        return 0;
      }
    EOS
    system bin/"loc", "test.cpp"
  end
end
