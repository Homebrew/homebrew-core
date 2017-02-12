class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.3.4.tar.gz"
  sha256 "01fd16f0f82e016da95c5ad66a0390372ca1bf1ded9981a7a1f004e4a50bb804"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ec3ef3b6b69265ba1d528c7c7faf2ab77278d3c05b8770d1ac0fb01f9d9e0f" => :sierra
    sha256 "6966c2dc9e8cdbc2affece5a5db37e0fc7eb339f0ce7707ca4080d3c663030de" => :el_capitan
    sha256 "348a0501c8a261faf0b83babf4227746551675036992786847ff651fa86c1d62" => :yosemite
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
