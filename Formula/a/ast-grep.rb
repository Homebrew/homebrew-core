class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.42.0.tar.gz"
  sha256 "503fb2c587e9376804fc39fbb4dda787c96093a6605d4e8bb67dabefbdc87fcf"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "febebb39333337746fc3dbeff41b33af224ef3b67dec659ba201cdbd2a87a57d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18acc1afe4917e8f07013e938371af8961875f0bbe52b5b40def3ae7b0a2ed89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "205affc44e57beadc0c8a354ca769ee491caba54bedff2f87638aa7c61c76f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed8d36bd0cf9cb783227face7d2dffe5cb9f98202554a23fb6c548ae5f338d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d10d2d756f99433d9fe8d3ebe81b0dd426814f857b690c9655e2e9c4ed8d9fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f1d7f32cd5939c432ea19a2b5a064bf53b16e6a02344968153eb072bd69624"
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
