class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4918c0e03cac581d56a6b74d9288859d089c26fd8b357aaab68936cab724a196" => :catalina
    sha256 "70c2d1e105fec5accfb3742ddbe98c1652ab378206e47507f9914fba056a3f87" => :mojave
    sha256 "30251d437517d5765dc5ae330251d3b2989dae1040422c5b6a3a94fd75c67d84" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
