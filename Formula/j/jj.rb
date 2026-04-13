class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "ca45f2b866ce2fa25c7fc485e6b168cf055a39b1eab0ea170738c0b7e86d3b33"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a084677111387fae1fcefe58dbef9279fc64f538d947141e31dd66fe56d761a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87a9ca6764b4f0a50a92e2177368cbc1b33185e7ff9f588ecf6039987cb325a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5840611c17062cf1e9c846562aade986f84a86c0fc1752e377532b2fcac5dc5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44aa5827cb460127edfefe89bed75999aa0d231ef3f7822680522c8f20ec24ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f4006106855ee07ca69b4f8a9e8da228b1e0a9180cb6d3e208de151335f12e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc31003d66b4b9e812e5a34cce03f1cd7405e7607ecbd09f5291b6e283a8885"
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
