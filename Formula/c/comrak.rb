class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "a8e1ca07ea266b4b5e1d568f1cb8ecabcb59fcdcd1517c0e1b49f07652d38df1"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b10a81368053fbcc0354c21e60cf306c29fce7ad486d3339ea7f3c38c51e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4def1ad6497988785f4a52dbbb400d7183ad8537c526e019766117d760aa6081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6564fa1366a6fe91a35676b6304ce23e6ce177c26ee7ee992606d0456e5be88"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0c12a4e8ba4600c8011ad613d82d6d0dfca56ca94aa82a5748244b2f6f13f42"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3376b45b4e38c8a89ab332afb3d0626f2abd798f263067cf423f4d59e867d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ead406eb2f67fcc9c2b11be8129525d348362c898d019e2c83681c480811cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c21a99c0f9f13e2e13424a4a5d94cc18ccd448f8d3ec98b6b3c70b13a4fde44"
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
