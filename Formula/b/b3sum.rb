class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.4.1.tar.gz"
  sha256 "33020ac83a8169b2e847cc6fb1dd38806ffab6efe79fe6c320e322154a3bea2c"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73c42303e167e66e27ab4acf63dcf3ef8b1ae0f08bbdd7352862c269acd685d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff332414d8dab7392ddb34b1a1650082532161116f158b05c242f74414d3a1be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1503b08de6a5fb0aacd1e43ada99c3f629e00d897688781e3d84289fd6289f66"
    sha256 cellar: :any_skip_relocation, ventura:        "8d4395810c8b2b981c87d005c446968282ec74961db9fae2193f8ccb10c6df26"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b1df0cfc20fa00a9aa5839997d64e876bfff3f38995e2b14c8b296624eaf37"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7f7799760a3d5f25b378e12e1869c90ea9b3d37e72a5708a556fade40719162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07eb8084d05b3a054f72fb89215f1ecc15856111e80700866922bf0a350dd819"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
