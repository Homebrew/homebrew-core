require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "http://entropymine.com/deark/"
  url "http://entropymine.com/deark/releases/deark-1.4.6.tar.gz"
  sha256 "6b45028de3cfaa589f49f5290e5d736d4104f5fc657ee6b208af9e9899fc7caf"

  bottle do
    cellar :any_skip_relocation
    sha256 "070b4cdd7806bdd67fbf17af2789a9e5f4041c094a4e5e636cd14001e7f0236f" => :mojave
    sha256 "d0b5c220343bfb1c65373c61e7f5676294860c5d7a934a8f080d79c4ef2bb487" => :high_sierra
    sha256 "5631ef8609234b791f6eb744d6f6097ce0f75dbbb4ce2975451af7e21ebe57cf" => :sierra
    sha256 "baebc1b49688c321b02cb9cd84d727f8aa5e1d66a29bef86d8ac3f194411efa0" => :el_capitan
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
