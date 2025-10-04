class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "2df520e5757a6a42a73da83e65aa2fd1c9e62aa73d50df5f909409a6256a854d"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67176fab0eb03f21314ebe812ba741b4d906b5d98e3e8d2e4f3be18927da87a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a19753f5aa7c5c08938646b7c01c5c7bcc2dd70a0fe79bab310b59e625327d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca18cab84c4edf8890e505761f467f428c4936db5c191c7e74f9751c78b11108"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b5af510c054f38dae93bf2ac6cf828eff62c741025ab711922776abe192b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e392c076f11085e2e2afc84d1eaa0397c49a528aec7aebd2d78188e95a9778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "018d1ed563a4f2b847b671d5631b046d35ffcb1aa602c94943b50a4807adc71c"
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
