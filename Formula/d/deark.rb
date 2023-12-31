class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.6.tar.gz"
  sha256 "6a4231801d08c7188aac692ae3054f54aede588988bed1e35b52d1a30dde62a1"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dffe74f23bf5f9546ce71e13c0b2e39dd64356a5f2beaad51358c2940ef4d47b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eba2bc765840156d1715e27cacf943855765c18ce56ef155e36dd664bbc55e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0ab34bf2bc7bc1784adbf09fbcb104631e892671003c3c041b36e4e004f0e8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6a3340be7431a41ac8af91b1ac36c28723d171800a5a5a5caa4f50321f146f8"
    sha256 cellar: :any_skip_relocation, ventura:        "a0420392f98f312347cd51bf61ca781fc34416cde3d2952081f047fe692e74ca"
    sha256 cellar: :any_skip_relocation, monterey:       "76b9a8c23a586c528136ed1df90dcfc7679b006007c8462b92fa2ffff22e6c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0c02ed4e3637994576c31d2027576c560fa68527408aacf69693fcc24b731b"
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
