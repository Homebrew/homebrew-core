class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "f6a1916193db99fb20ac0220a121e802ed1dfb5d25535075e7ccbbfb0ecd8939"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89aa1fb93b4a9f00fb5101e1f896c5348459cf08e9891277a88dd9397e415aa8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9dd39a48f2fd5e1ef8739b256edd2042e396d1263005fbb3e419c3b844c622a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8d88e03856d6372fdc6ac838b55c38cd6aa0b2986020b59281c4349a4bad367"
    sha256 cellar: :any,                 arm64_linux:       "5f0b806b08ac090df258b60243d04516dd85b47b9e7697be7166836918f7b740"
    sha256 cellar: :any,                 x86_64_linux:      "2e16f535beee2e4a1e26323aa77e754fe11f526f078d03a8b8ce721d7f042b08"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
