class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.3.tar.gz"
  sha256 "23e1c05c88417a27dd339895dd4e63b913a5593bc036406c2e81742c17757669"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8571ab11b57e2e90d68906b9a930c8f9667cbe4176bcd3d80a82bd7c3cadc597"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba55a7b86b72f8de1ff901c2f927c07dde145e1f21281ff5bfd848120df7f5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "84180e4b5798017745f3fd80b93e098d58b71ac187021d2adff329c0865eabf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "94d21e0cd0b11731d5c57e972a70b4119fe7a38bc29c4d201faf15aefe4f8e8f"
    sha256 cellar: :any_skip_relocation, catalina:       "2a66f100c4cedef2a12624884f2cb321b34a81a62e458296be66dc308bd78d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03470cea3de90c84d08119ec61defdb5a49315c02edc5d28f1c3836ff8e89bca"
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
