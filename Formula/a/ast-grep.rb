class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.45.2.tar.gz"
  sha256 "b372fdc542b050336c5491c5d7cc91e0648c107bba90c3ad8e02913e5cf2f4ab"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "124d8a95200a444d3472ffd57accd11776cf3784f95ff89edac4a907225caf0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7467e291f6e5a84e9f33d362008ab95b07cc06118682bddf62ae7d3fa47eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360de738b6cae685fd270587284d54a318a001485271cf65cabf9d9013a5a84f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9948fe699ff1e00f67399e5117a136800dbe4f12fa437d49f08567f7a878e19"
    sha256 cellar: :any,                 arm64_linux:   "b46cd3654f0522f331a74a622f145dba64acaf20e7413d53a511ee1cac07c47c"
    sha256 cellar: :any,                 x86_64_linux:  "51bf73efa314f51e9c5c6cf67af9b21c07a87a92a973dcac145ff74c433960cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
