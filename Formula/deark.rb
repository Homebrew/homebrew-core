class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.9.tar.gz"
  sha256 "29eb4efaf598c7a8f3eadc8db40cb303852677b5bbb133e5c55b7a9e654fe25b"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c454c03d484470e2b1a8d66b0808aec7f04ef89c607b0a52b2e9f014e34121a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9a466bdfadf7be7d424bd644f825e39e946f2db70189a2fefcab2b4d447314f"
    sha256 cellar: :any_skip_relocation, monterey:       "a27afe034aca4e057479dcf89a1973509e1e9431577b8ff4e46a03b8853dee69"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce395c466420484460ed1e2387c4a989a99586f52bf0c32ec76c2af28eacebac"
    sha256 cellar: :any_skip_relocation, catalina:       "254c3f11d539f1115b805e91f6af98201f816dd30104b36f2b250ebd7f8d38ca"
    sha256 cellar: :any_skip_relocation, mojave:         "d8d7cfd4a923be61019683d657513cbf749da3bee7e804642b3bc5a99ea5776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4175cbafb12714c7be36937adad34769f787d4c2609fe6a2e61ceae3f1afe9cc"
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
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
