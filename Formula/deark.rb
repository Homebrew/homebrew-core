class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.4.tar.gz"
  sha256 "21f7c9485f228bf7067fdb6d2336e559985e140ee790c97352ecd2a863fdbade"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ed4fa3b539e020e2c4afa580166293b9d148cce9caf602bb3ca994139abc2b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68115bc2870357c15a2ebd94f70382116eec4c5d94500421c93cda21fa60696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38837770d573c53e889a75d9dfcea9701f33539d3bd350e96721e4dac43a5ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "def3274201210f991dd0ddc79546bf1d36a900bcde3e202b26a176e3949dc2cc"
    sha256 cellar: :any_skip_relocation, monterey:       "18e3ce42adea9c623fbc926e16106edd362103a0d9f1bcda251e73bd12c9255b"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ff6225b7606a00a2786398264653fe87c4f995922ec9418ce3b400b8f1da0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162e85f0bb303675e98e5f421b398512beb7c5ea0744457642e6af265bbfedbf"
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
