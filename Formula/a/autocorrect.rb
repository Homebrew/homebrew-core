class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "6cd69bfb8a49dc5653576f7b8313a47d4d714089ca3d4b8b2ce1e48a26731c93"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dce1d4d2591a91cab1d760ee012032e1ee9c07f45fc307992e6e05d03736f8ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8902c3f3157daddddb131744b04faae9f0f6894cb114050d02b14f1a427aca26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdad116b3f5af050ef265b98a0f102ac1e6602ada5b06343d88a2d28947ba6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "95a7a858943cee598cbf6c089ba2931e7f77d6ff0ed7503c1f054a0e1db42e61"
    sha256 cellar: :any_skip_relocation, ventura:        "1a7d19cd741020393835bf74afda0a0c3b1302c578d0bd79f935dd730d160b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "73797bc73e50d69c1011deb99ea0e53c31a7c1e71f6cd72ff2de4a8f4645a63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dc5ca4e1d33ee52e613b48c2869d955fe685326fc6c560399ee649eb5ce8fe7"
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
