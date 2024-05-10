class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.7.tar.gz"
  sha256 "fd230ce0bf929f3fdd1bf7c9ba88d0ce6bafd5cfda819cceb96c110a14165dd6"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d42f1ad4eb6d9fefa253e8e7bb68ab876a088f8023ea14745a698018d68a6cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84c52444496dc5e0d75382425f947c6265066fccebcbcbf1062532485db1bfd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0846442a67b36c2258fa23c521a881012adb59171d7680e068f809fff98c8f10"
    sha256 cellar: :any_skip_relocation, sonoma:         "9753e603fc673c17a2e78da1f348bb43340063978baec6f3dd1b3f558cd3804a"
    sha256 cellar: :any_skip_relocation, ventura:        "bea508c01fea0aedb8ca87beaed881eaa9d2c63dbf48311cb5581f824c48553f"
    sha256 cellar: :any_skip_relocation, monterey:       "a7fe24ded26f60ed48f91fb6cb7a323cb655c3fde25eff9aaf1e06d2bd4f6f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62854960a2711e351eb5adef7c3855086ebe1dbf20bab501167911a34dc0f0d"
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
