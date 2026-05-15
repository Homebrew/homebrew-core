class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.42.2.tar.gz"
  sha256 "c56bc5ab3fe8b3589c3d707bafbc52c79094e7f397bbf39aa26f14aff97bcd49"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "919d47cc595d5bc2d03851ae0a9d0d49975c7d99a87e403a149d9ca7c33efe79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21bf7a3fae18297a5c0670ae009f4266230017814e713892e9c8267cbd8b0aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92f368b0322c1fe26516d4a7b7a55a9839c886937ef8cdedb271154b18121be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c273e048945529e9a6027703e97f8613299e3daa6ae580bd7c5787cb2757c197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d309295de5d8314b999012df2504991b5f156f627ce48f9179b7e8bc6dbbf2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1accf3272d0a70898b3719409f298a125dc8dbf4bb0da0a0df46483aca6d9f04"
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
