class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "68adc783055136d7012d8a9f0f2ef1e876f92c8f8708f22977f89a6a1fe7e185"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59302bd124b16d4c4065348fdcbefda517f75cf73cb651f6642ba55b4c72f90e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a4338dbed283b292993e99dcc1e6ecbbb4052a80edf7560bb1acb5a8c7f9a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7deb845bfa4cb5eb8e4b9a8c75930f0d1b3998b2f84d83287449cd6ce170e0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "55f7bfae750be64d5ed30f7ea5f0cbfdc87b87071a8bc9341f8f7c490ee22f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd00ac8e83df9055c76d39fd4b25705095d4bf9ce99125f59921537b8f0ee0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639ea7b38abf329368c69a68082ae14b97e9cfeb0fb2ed41afa359fc56dd2d1c"
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
