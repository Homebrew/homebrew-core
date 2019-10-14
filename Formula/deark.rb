require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.2.tar.gz"
  sha256 "817c641767c546dd5b3f466fc8408cb9edd4d67d8756bf07bf322f50247c3287"

  bottle do
    cellar :any_skip_relocation
    sha256 "c26268ffce7476c73cb93e7fa4683f4efb864913199588851860a1cf4abc392b" => :catalina
    sha256 "16bd12bfa6d0ca8f192a1b7a8febf411cae588b1887d18ca2c48dcbe46357fe4" => :mojave
    sha256 "f7fbcf71cf7ce9f6e4f402e8a22b3a11bf213790fb82c2fb1865da9aac78671d" => :high_sierra
    sha256 "41adf7c83aeae1c945d3007e860993e9f8845f6a1f7c239b86327958b9ed470a" => :sierra
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
