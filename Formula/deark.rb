require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "http://entropymine.com/deark/"
  url "http://entropymine.com/deark/releases/deark-1.4.5.tar.gz"
  sha256 "2dfe61cc7bfa927e1702b2312b3edb9e5f9e67bfe460f5da3f82652f163e31e0"

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
