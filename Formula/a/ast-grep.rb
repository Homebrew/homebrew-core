class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.38.3.tar.gz"
  sha256 "387a20ce819a37dd073a4b8fdf383ce09aa3627fafe79cb17612c5cd0657ef8f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508bfc02fd0988fe7771ca31272cb604c31c382b829918ab303116206b537042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbbc40170248d42e58bb88be31b51e34e93452b3779b413677a949bb6b5cad77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "642700f4798562dcb84b72cb6250818023fef0919f1b597933a92da0902ecda2"
    sha256 cellar: :any_skip_relocation, sonoma:        "315f45296b4d67a66e1535e85f87b6cc150f20952f4d296bfc0aa2e4c5acf3da"
    sha256 cellar: :any_skip_relocation, ventura:       "b88f559d1dc047f478985e5fa8e7905a0c60ea9acc15f1313aeece0b337c8b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51aa22b0a6c9e9e520b97adeb59d4c9e3659fc0eda962318ba52fe0b4967ce1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f9d2ba503eac30ebb2d09bd4cc7e92d904c7a935d7fa630dfa38ba3976bdad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
