require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "http://entropymine.com/deark/"
  url "http://entropymine.com/deark/releases/deark-1.4.5.tar.gz"
  sha256 "2dfe61cc7bfa927e1702b2312b3edb9e5f9e67bfe460f5da3f82652f163e31e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c73f07c4cf4a414827ade6a4b982d478352c0f7bfb739481278198df8fbec02" => :high_sierra
    sha256 "913ca3d03afc1c9ddd7f03a0ecf9a31245e11471c366d7ef8486a612aef3d328" => :sierra
    sha256 "914a5f782e78b109b82d4d813ac2025e6499ce44c1d2b1b3fc5c78799ad4eebb" => :el_capitan
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
