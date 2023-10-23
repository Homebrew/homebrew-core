class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "fa254dc9dcccf1411c0fca91fd9bcfb2b8160140a6b3d1f068f186d085ffbba5"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1606b1d6769503c3e9ca4306b00be5e35151a6e5109c5d8a0cec64a4c0529570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f673a7b0a3533eeff4b25f1fff556a135947f8c42b598096489418f0b12f5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449670b34d95618989ca681cbd991a121dd2f2d7ece55fb0a6ae5d91f785347e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40744d4d514c4c5d6291e279a6d81ac14e8a7b97b333f40065030924e106fef4"
    sha256 cellar: :any_skip_relocation, sonoma:         "417a15c5d9946b33531d65cd3e38f5d1a141507a3717ec8b248484fdf6db977b"
    sha256 cellar: :any_skip_relocation, ventura:        "f1a4aeb05b79054862bf32f8c1af804d1bec82e69e3211caec528d95fbc6c9ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ab9a741e41072a45054a027d9953fb5526ecb5ab53ae1216806d1c903e20eb90"
    sha256 cellar: :any_skip_relocation, big_sur:        "deefd96c6825ea4ff394cf90ef8d78e0446b817ab41e5bbc34af4b394a77c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f8e1642386ed2fa7b024abc9dbf443625da9b61fa0467028451547171bb3c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
