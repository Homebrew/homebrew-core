class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"

  bottle do
    sha256 "5700a3aaa7b9e65ce5205517b9313822dc655bb4f4f4e1d3e3d78b0292c2dde7" => :mojave
    sha256 "2c66f5b54d8769dd96f34992db4dd6fc5d84344ce16553f2ee47c6fc6818a861" => :high_sierra
    sha256 "276bb55a29fa8e24a968376e040a648aefac8710e968c507040a12a2d5979edd" => :sierra
    sha256 "c3a745729bbcbb8fbda867e82946ce3d20078beca4bb08265ceb6467691ca0da" => :el_capitan
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
