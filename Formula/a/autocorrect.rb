class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "b67aff1eeb1e654442f483465752be9845a5fb563a1b526205430ad9ae26923a"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e7196f18557ab32864393e1d414ff6896868dff99070cceb474ede380697e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad6fb8c4e7a9661a6c70c4a8925834055fcb68413c9131992f77e0ff5636e20f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6668decf00f4ab79554531ce35db7408ffc9001e4f32c8bbb94cfd85cbba82e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf61c324ea545395bbf5ad8546780661d14b56e6b14250d2d56d94a58af8b61f"
    sha256 cellar: :any_skip_relocation, ventura:       "1af4a146c12edaf663e8fba23713bd0a445a07e6d8daaa03f1b894f79ee82dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7678a3ee7fa9e8ce32b3955201a042c97742e4832c79a24bded9829b201fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dece54fded065ba1a0b2a21b524212285b130b849f74b95e7361ee85f232c064"
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
