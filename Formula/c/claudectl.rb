class Claudectl < Formula
  desc "Supervise, orchestrate, and connect Claude Code coding agents"
  homepage "https://github.com/mercurialsolo/claudectl"
  url "https://github.com/mercurialsolo/claudectl/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "601bad4b04822b5910ddd05833de955d238874476270f0a0a26262a8a513b6fd"
  license "MIT"
  head "https://github.com/mercurialsolo/claudectl.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")

    generate_completions_from_executable(bin/"claudectl", "completions")

    (man1/"claudectl.1").write Utils.safe_popen_read(bin/"claudectl", "man")
  end

  test do
    assert_match "_claudectl", shell_output("#{bin}/claudectl completions bash")
    assert_match "#compdef claudectl", shell_output("#{bin}/claudectl completions zsh")
    assert_match "complete -c claudectl", shell_output("#{bin}/claudectl completions fish")

    assert_match ".TH claudectl 1", shell_output("#{bin}/claudectl man")

    assert_match version.to_s, shell_output("#{bin}/claudectl --version")

    ENV["HOME"] = testpath
    system bin/"claudectl", "--list"
  end
end
