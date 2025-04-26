class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "10efdbaf2bf3e5e1ac672598608ebb434b91aefaf97cd53795f4dcc4e681237b"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7f521e32cb23ddce0780b9ad08ffbb282cb0fb397ae8b90f39ac6804464992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beda25be453e44c6e9bccfba0b39488e022ecb14c5525770378e33496db74fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97fb6ad180d0a28c8eb11a0696aff25cb246e70b3527d56eb37ad69c1cbb967d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46a5c150623cb6efed58754f2537c268a432ed3fd378048b3ae4db89517756c"
    sha256 cellar: :any_skip_relocation, ventura:       "65cdd1a7e76e4c1df017d988998f0d430638c63a368a6d6cef6d03da2b4a888a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401c6718327d1773c5f5e04013d5d9b6aed38ca95f6ba226ca95e2af76001b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e450c33c1d53e9f7b6ca6a3e24d70d12fd0d9ba5c0b9348f901c439630bbe9a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
