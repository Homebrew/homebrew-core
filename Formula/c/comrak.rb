class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b09ef8f84e7f8c7ef6d248dd7fdae3f2ecc3e511b7ee7db20f3c196832353782"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57faeb8e33ae1bfb8f26cec0b9064102820f887337aa2101c20601ec4376e6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e76259e13e1aebbb8c3eebaf6916a1f6ede9bf748aa895f5c5cb692c084a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af0e09958c334bbd1ced95d663cd5516089f138a5fbaaad9abc133754cca5566"
    sha256 cellar: :any_skip_relocation, sonoma:        "212954f2f2c242dc6553c7a98cc3e9bfdd4e8b224e79befc4e0f9697a650f2de"
    sha256 cellar: :any_skip_relocation, ventura:       "f163c91fdc5afa92630d51cbc15ca360e2ca806490c66d5b4fc7038df03b1275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e7c5323feb6b9f926c973f104a123fa2800328020902b5f1194af3826c6c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a5450bc283b11e2d099da9a1c1a3a95635aa08638de1b015379818bd952e7f"
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
