class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "53514dba5c0df9dc734825d5e8a29f0ff0b4c7d0edc9d521cdd8a5fc66285dae"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a9768c11566637f92072a6775f5ee49be07dc63d3aa436eea17980ddcc8b4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae2d6bd75b7357a1f5fcb8e4340819008c6b1043c72923e67fd6faa9fcc0b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "418f2cb3b252ccfc7eafd1eb0a416f930b9e430782abc76fa4dedeeb7693b0c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7e207cdd44294e91e2ed6e3459f515d33afecfa97952f9009f3693abdf958ef"
    sha256 cellar: :any_skip_relocation, ventura:       "cf5034ea11f6ce60090ac1b72bd2dee9eae97f001e74f2d8b408d0dfb5696a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53cb649582def6f45fa1a013e7d242d5bac24bc16dc9d60735ed370183af3dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ad9962ea5a4ce0061b82c08ff924e2929638773be215da3df678c95d7cc72d"
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
