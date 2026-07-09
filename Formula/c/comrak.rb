class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "bf14ae3d07b620f0d5186831e62021161a2de7f112295cf107259ec9ebc2ecd8"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff09c5773d937e165564a30e0ce5c8c55f20950c1856603b3862e35dff777194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d87003400d789c796237c9e66ef32fdd6fe7f5261c8833d859b262a5bc441e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0d3aebd109c264fd34c27925444e9b734a454effd30aafe55022e27ae9c205"
    sha256 cellar: :any_skip_relocation, sonoma:        "0009701bf0bb277c4192e94caf6065e2c0b57927c98efd5dd1d1d459b59c59d6"
    sha256 cellar: :any,                 arm64_linux:   "8430f59ab448b5d3890b84181a53482608337455022be84ccbe0050df861f087"
    sha256 cellar: :any,                 x86_64_linux:  "c706e67a29973667c8b4384277aba478dae54a5f44167c9dd2939c0401d9d940"
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
