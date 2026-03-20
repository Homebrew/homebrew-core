class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "44c150168c031b031c0a96f4c45844a6338c54518239affc6885b6afff76c5b7"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7f522f9c00c3db45d09f8d9a58433b2cee004b74754329841be0367ca3bc334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1803705a8cb75442d14a0c6be132f7c34df70feae037e4b10fdc80955959b794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5a81c736b864af7d3e952207896a804e8bf727ae0d8a142496d06b8b2d1b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc47f706d6b871b5e6329eb3f11dcf35a3c09b23cd53cc23936b137e5567262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d8130091abf5d6453e54f06af162903025d80e442a26ad94662db6f89e4a3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af87349d2cf3404d589bea8bcdc45a3991b346d85e756ec9fcdd7aa994f33a0"
  end

  depends_on "rust" => :build

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
