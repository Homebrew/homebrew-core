class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "77f6c0ab30a9b204d0b2a417afa05915fe8459d9e96680f8edcd1a3adf121224"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c83a9447e3707f411c922ab1bf33e5b55822b52a8f22d61eb3bf850c7833cbb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ca11de2a02152b40c889375d1716e818d530d89beb7a8518653dbf2b95253d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3dfb2cd0928222141e7d2b3ae726f1906faad61ef089c8c54476b3889892db5"
    sha256 cellar: :any,                 arm64_linux:       "a59d21a26dda9221b6dce81fbd875b5c778a96425c842b18d16351961c99d668"
    sha256 cellar: :any,                 x86_64_linux:      "066651b274231bbcd172eb749a18e563ad5e7930ed8147bc2e08b0aa8a3c1e9e"
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
