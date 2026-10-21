class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.0.tar.gz"
  sha256 "aade9c7059f1588d322dcedc058372325758211bfaa46f7170c097ee9da4b0c7"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ec4a04d52389845af5892106fd9262b87c9d4c13cb3679319a23e82cc309321"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63d8b7ba96ad500108f91a42e7727494fa021d8f6382debe95f5a484753ed498"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c406a372da3a6254c3ae8812adc51ecaed121c308f232bfbe94be23e35fd44a"
    sha256 cellar: :any,                 arm64_linux:       "e5b7b6021ebdb0f2cead32baa600bbff904ae01f50ae0c944c9ed4d4208028ff"
    sha256 cellar: :any,                 x86_64_linux:      "3407d8c5e8f8a75dabc6c412a1772fd62bf318d13f16994f9315525e5674ab9b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
