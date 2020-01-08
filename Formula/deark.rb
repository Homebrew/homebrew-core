require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.3.tar.gz"
  sha256 "1aede0bc5ca892ecc66a1026026504d1c582f596b001b160e6cc26c1a8a63089"

  bottle do
    cellar :any_skip_relocation
    sha256 "aee57506ce46b2e68ac24bf69ad34e2064995d4f48a56e6cde455fa03bfd36b9" => :catalina
    sha256 "12b0fda7a6b6030ef70c3a06985581a989fad1e12baa692fc41fb6b7827890bd" => :mojave
    sha256 "94718e3c67b4f3044518fcff031f194c6a3daa24ce36cd416842f441319f877a" => :high_sierra
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
