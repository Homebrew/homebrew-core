class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "f68631135861de41f3ba83c84d7a239b679400c65babe1081abd4d22a78ef392"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93424588f7232bd5364f56974b21ac8e708268570cdb167f0c18bcb394acc37c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "329076a8511cf3748a3683aae361d160af91e6ad612e407a750322205b662007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc1b0f6245c16e8be0497de181091e71e356c8bf500aceceda5f446eeccf7314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5e172a485ac4872d849b6c282559c0fbd3e29201f9c0bda458323e31292b5337"
    sha256 cellar: :any,                 arm64_linux:       "bdc163f9a31d670f6809495db5702fd4631ed62022fda42bccd7fc3a762ac4bd"
    sha256 cellar: :any,                 x86_64_linux:      "a3e6525cc1020d10e0cdd9422fccacc6e399e59424a2b5d828a5ff784e68ef13"
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
