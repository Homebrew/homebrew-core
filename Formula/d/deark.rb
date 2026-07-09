class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.7.3.tar.gz"
  sha256 "84f9e0134830389e4ab12c89dc09cf42a3f885ec551254e9fdc22952858add11"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaf910ac5f678926c6806e8c988dc525255bb33565105692563dfbb9f5cfb4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec33cf7219bb1f352e5d55cd65b0a983e4ea2dcabbcf83c702fc066136e5b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1deb5f8d935644c8e479ee9557c9fe70966aad4550de1f73dcdad6933401c146"
    sha256 cellar: :any_skip_relocation, sonoma:        "90395683e64ac16e4216d2168bcfe5425493ee9f81fa63dce338a863094fecb8"
    sha256 cellar: :any,                 arm64_linux:   "f390313a7dfdc00d03176d85d72ba505c3f529dc200e45cd2d5b611b9025f810"
    sha256 cellar: :any,                 x86_64_linux:  "f2c1f2e21e08f76751e2435e523af16c94c4e6abe877ed30d65b8118a46ab336"
  end

  # Backport for macOS workaround
  patch do
    url "https://github.com/jsummers/deark/commit/d9ad63f9331f7d804c4978a644272810e200eb4c.patch?full_index=1"
    sha256 "0b08bfdd88bd0ff99208c6eb96eb72fc91f421c633a55bfc2ec960c5ee74a1cf"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    require "base64"

    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system bin/"deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
