require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.6.tar.gz"
  sha256 "716bc1c2c0d6e40a34a1edec62bc1e93d14c6b70c9657d977d7415783009a278"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "68804787d02c78c38d58b3fb09136b2957cb9df252be1752a961aa26297bdbe3" => :catalina
    sha256 "bc52c1bd04e7f78955081c5b43b989db9ccde94954eb9980e7186c98cb5a0114" => :mojave
    sha256 "267616c6a3ec1ed57a5ba6b3744ffa851d6f3513210e6896f1310ed9dc379810" => :high_sierra
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
