class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "0ce97f37c67fca030d70b8736cd9ca37e3b5b0685d4e003412b1534f074ca122"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b0bf8a7680946b9c4e42cdcc157db20ebf874399a544cccd7b5780fe7c83251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7086202f776a3ff48e7f2aa8e8c1258ac60738e41a83d764907a105a979ed852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f80fe1df44460fe21d26e769cae5cee6c07d1a821885653fc558a8ce189e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "71deeed45b67aeb0a16fd6bbff17b02c3c1040e46261e550592c741e6c48baa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51792d1ac66c94951811169009efab41ab374fa5aa70f35cfa318c6a3df87ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e20742b8008fb99dda54a8be90ba16dfab7ba700c60df82f2d229defec8faa45"
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
