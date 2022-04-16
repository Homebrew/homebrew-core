class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.1.tar.gz"
  sha256 "6d3e6853fb1342eb3ead53cd9c10496e262c885397cfc073529cc880cd3dcb46"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be4c0c672bca447524ccc2366ca53ea690e28fb1761d8a53ba3620a19e8812a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b3a9ad3e460f95c8978609d854843693c541fac952df478ef45da434e35f5ee"
    sha256 cellar: :any_skip_relocation, monterey:       "ad91840a06cc9519372eecab073fc374d5391d0fdec7057130b66abdee9a1673"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdb4a6890ac0a7d66ba07b00d04602dc260f7f1be8bd42fc46f2a0eb4081a84e"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a7cf1e6730e266d3a5673424d81ff1d812011590e2a332113fde131cb75906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26784ef0fae8fdd23fb492beb743d25d78238efd2badf76e2c8fd7607a723bb7"
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
