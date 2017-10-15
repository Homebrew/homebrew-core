class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"

  bottle do
    rebuild 1
    sha256 "fda06bef80d81001ce119d7095cf6f06e2d3bdc4d940848fd52b5f68740dd5c6" => :high_sierra
    sha256 "71e85c59da5729deeca005b793ade159a5b33e77ba2cbd65c622dca26226c6fc" => :sierra
    sha256 "b1a5522f89a1ebf4154b3746eb9d5b8fada1b3167517731632423ac152b6b7be" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/loc"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdio.h>
      int main() {
        println("Hello World");
        return 0;
      }
    EOS
    system bin/"loc", "test.cpp"
  end
end
