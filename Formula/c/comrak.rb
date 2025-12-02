class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "91d136008082a5019df88255bef198e21f177cf7234895be4957ffeb92bd886e"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3cba8322e19921e4aeacb9549bbcb8907c9943d51a4469f09b1e2c906a80b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85c2c2773b14dff47c4032e5adb8a51263b753cbe2d5fafea5b386669cd288ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba44fdb12292329f487c5fb4c7b624287be3e8608f1a845218618d3ed9d707f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7d82f6335c617c5dffcd5a8ec503762a61f9a38bfa3701df4091ca9fcd5acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5c0144d170f0d6ebb86b8daffd57108bfaafd89611acc5655223e45fc03192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89dce6de0314345d082478b479c650ec56811bb31f70b479d0c2eb5e2cb5a5cc"
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
