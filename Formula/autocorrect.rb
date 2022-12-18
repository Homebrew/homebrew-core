class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.4.tar.gz"
  sha256 "6d06ad99f99aad35400a8cb5bad72eac1496b09953aaa481205ce701a6a3c56d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235a965c9a91c5b5954d9c31adb06020ab63e02553abd3eb0a46d5c5a0201247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df1ee047d15b9a48da8d16918008505db7702ddec2a26e9a9913ecc3550ebdf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "004ae01653bf0ba16c762910b384c8092f34ed5d45b162ed269897722abad8b0"
    sha256 cellar: :any_skip_relocation, ventura:        "302604c1dd22f7cd870cee9c9481c1177d38040fa7f567c6357c1f870dd1f05d"
    sha256 cellar: :any_skip_relocation, monterey:       "e32cdbd2c47916f576fc61a232b5f03cfac6b580a43e16c08c20e60571c45842"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9275c227fc2cba12c0177ab69aa21f441803850d97de7bb2fa7adcc83db32dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2950e5f933d69568b4b5257d1039f364a4b86e7e9b6169e8d339f0b5d4b05c2c"
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
