require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.2.tar.gz"
  sha256 "817c641767c546dd5b3f466fc8408cb9edd4d67d8756bf07bf322f50247c3287"

  bottle do
    cellar :any_skip_relocation
    sha256 "00f53a4073d77a67c2e8d295a68a955babfa90b6235ca3fe77e95810d183beb7" => :mojave
    sha256 "257c40c3b7e30b1c61846baf6b8f22c550f540967b9b7be0b1aaa7864dd3645a" => :high_sierra
    sha256 "7393b4d3b5034571e2b728d9a5fd290e4b3d8f809723de1f71dd5216bcc291ca" => :sierra
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
