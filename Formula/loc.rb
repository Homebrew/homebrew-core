class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.3.2.tar.gz"
  sha256 "0b805d53326f269e8fe21f709dc69947820fda1f291040e9225f93aef614daea"

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
