require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.4.7.tar.gz"
  sha256 "f26441f7f361e9f4bf584866d46995e35441ea88f269cb6c024881a5d17c11ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c25be43a16ed39998d9990b5f971b0ea826c5656fcdfb2e787a6a63ee674d66" => :mojave
    sha256 "08b71c8e1e78027c5a2803ce561460c61a7b85a0d9ee1b5853d388032b6c3549" => :high_sierra
    sha256 "68c9616ad4a90b7b364e1918ac6938a8b2b8bc407a97fd72b437dac6aa0d6230" => :sierra
    sha256 "0927ea0354c7f6da3d71dda9cb060a407d4325eba2e6c37da62118666936fcb6" => :el_capitan
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
