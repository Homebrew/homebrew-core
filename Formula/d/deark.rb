class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.5.tar.gz"
  sha256 "572be942796d44085d9ffd3cfe5c55175bf4aa315981adb65c45f9d972743ee3"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4737631a58d8a352f74562059ae8ba7c19cba6d80c13cdfea8abaa75ffbe7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "141c18827d0ced50178ba80affadeaed60fa51d461a6e806de7f12c45b5b4ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7388420edd42e8510b78fe4782e825b748a0416390e1353924c54c4c46266d28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304e04d6a884a11377eefc8e60cfa3755184389b4ce833b336d29a68126e88ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b625a0d9fbf1599bf211ef24692448331abdda40318484b9f22c1426de709991"
    sha256 cellar: :any_skip_relocation, ventura:        "35a1b0e34a3dd56054ebf95eaa28c33a613b388f7d795d1fe2f32af96debccf3"
    sha256 cellar: :any_skip_relocation, monterey:       "bb834227b65ddf9e01364c11a6f711156ba810d7105289e5bb8a38ceb703fd42"
    sha256 cellar: :any_skip_relocation, big_sur:        "a10b3bfa4494d6858e17acb7ba4276286165f97de4903c44ad9c4b0b45959668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f8ba1f7c111903c5832c43a2f43c765ffa34239e67d1d67fd30c6b9643f71b"
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
