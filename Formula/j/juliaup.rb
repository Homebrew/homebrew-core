class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "657cde15d938666a2bd2e86fe2f48fdad8f4681b56d542a1787a760667d2bf19"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9abfd6044b3638a3f4e34b2a9e2ac44d9c26a3df3a00c6fe094d6f1e8fe532c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90a758c077f1b798c11fed33f3267d945e1cc423ec9b0987351fee02a8e8a99d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4786499e79f563537b579929c6c33197e19d66cdaf86c21a19048d5ca3aeee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8737482da9fa84bc9fe1aeae0612feeb368b6f96b46c386c440ef5b25bf1049d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceab4d199b5c37816b1f60c17a2e678b6e55fd6273e73bb50eca18424f62260b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c4295ccab8ae580f098a52e4ceb18f9a6bdd17c7a3739f9203e40f02b66134"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
