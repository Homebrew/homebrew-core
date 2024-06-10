class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.22.6.tar.gz"
  sha256 "d7b247c6f868c4df3cf9563092480cd863e94fc633471b621ad89784b83aaf89"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0029446dcbc44a4cb14430d1c509eba2007e366c4834b82df3380c42007d2ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ac381b2693c90b6c65e322e7f431e2bb4439f6147772050a0aa3d9ba28f5e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206338ed909ed2ebf97f189a9cf61001263b1905d9169b008471b92878db56e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c52fd7434ac7472ab02f37d9950c93842337fa57ce356059234bdf1689e9bbe7"
    sha256 cellar: :any_skip_relocation, ventura:        "c0bff96f8258b21ea5583045cbc2a5512501dd586f6a797aa698584f2ea5b10c"
    sha256 cellar: :any_skip_relocation, monterey:       "40116970212a56374e1cc1e6100c37386c7cebe58a351cf3f062989b2b9e7ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6067b3ffb4505fc6b9085e92e195e5533f8ec0d3945c031692a2ec76f3e4631"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
