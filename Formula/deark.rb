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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd31b0d3ca42a40975c780478844c890e69f0fbd417153facd8d03d73bc5e38d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "029e1eebe7ab5162b076e031e97dbfa6aa7a339250bb66a3e949c721af42f81f"
    sha256 cellar: :any_skip_relocation, monterey:       "f016b88a7c7381c79858779111ab274babce86f7f93520c40cc17a3e1901d4b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7557c9e773e8131528189eb0f5e58e80f1664ed98ccbb108c3221f17b4d3dcf6"
    sha256 cellar: :any_skip_relocation, catalina:       "d5d1145f18ea78995f8004cfcdbf663cc8f56b6120070a6d0378a04928e2b7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea86049ad84d9cb22c0d651962e25bab6c295f1c2216d6d8a36f8bb105811acc"
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
