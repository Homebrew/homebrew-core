class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.28.0.tar.gz"
  sha256 "697adc13c11952529e8b6592b84b2cd3e08a57a13ebafe48ff0ef470e1ccfe1b"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25eb278e12d1ff3333412bc0ec3ac819dd9df0ee918c19037d2b578d4a8e3a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ef2a61cf8f0bcef41a8cc0c27a39cbf738bb09fb674af2cd32eeb2be8cc898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "271fc245c7ce81e4f350efe0cae5f214b0953f6d83c107c2a71fffc53a1fb899"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1233fc6842207b1f1e9ee2fa6a48ecd01e430e128f5df0839e9382bc80e1751"
    sha256 cellar: :any_skip_relocation, ventura:       "409692422376e8e79d1f42be932138f6ac41d5d510f53830de728876bb8bf053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5417bda578c563ed545a93d7a2ad354377cf2387e32f9607f556b456ade1634f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
