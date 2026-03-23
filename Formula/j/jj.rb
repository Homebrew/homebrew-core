class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "52a60f058cf66ba3dc0bf69f189e99763b33b6770b3068b2be4fe76ecd287282"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94418d1c38adb5add9e8e4a9de853af1cc61d6ab981959df17b1a78c457837c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0d6abf8ec92f512b0a8598ce32ec736330624c7be5057ff481fa0466385a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0469e577868ede409810d4fecd237a0b0dfe74106e707d38ebf833612e95fdc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0699fd6c863c0eae151964d64aa5a1e2bd95e729a3df571b14e8c858932115d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf180e9b14f44065ee151c2784c1b8616f17eeccbad42d760d6ff490f8a9626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543c47f1eb390ae92b04c750874d1abd2b0fa92cf6b905be36defffffa7764dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
