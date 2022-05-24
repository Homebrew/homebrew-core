class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.2.tar.gz"
  sha256 "199f5cd6c65cd23af9323bc464f0d33f53d22686135695b4aa4ddf2ec43534ae"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e560bcecac579e61c6e55dd4fedf07831d7f14ca84731feb672bc92b17ffaf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41b5fe260d01e8520ebfa31a9df1545be5aabeafc7def39e565691a2be5736d5"
    sha256 cellar: :any_skip_relocation, monterey:       "df89df680d31ba928a3f41a6c8beafd19310db780551ba4e9c64eecdc3488aac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8b135424c8da134b51def027de5207150ab81329fb999cb347d4fe0b7d4f7b1"
    sha256 cellar: :any_skip_relocation, catalina:       "823e4f833b2c843c5ffda4cf393f3baebd6e6bd19432187b47346166e6217555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84a83ac5ac0b5b06aadeb3bb744a08cff912630610b9f13dc4c7ab6a79e4a8b"
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
