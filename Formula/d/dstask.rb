class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/refs/tags/0.27.tar.gz"
  sha256 "85da92eb50c3611e1054f5153dc0cf90fe1b8b12219c77d1aa86a61384c450a0"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ee01e4bed812038f3734de20cab6be5da1d4d17235489037fd0f5f7dac25a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ee01e4bed812038f3734de20cab6be5da1d4d17235489037fd0f5f7dac25a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5ee01e4bed812038f3734de20cab6be5da1d4d17235489037fd0f5f7dac25a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6958dcb344570273f7eeaa408ee4b0ebbc4cc2d03fce10d8483b8c7e163085c2"
    sha256 cellar: :any_skip_relocation, ventura:       "6958dcb344570273f7eeaa408ee4b0ebbc4cc2d03fce10d8483b8c7e163085c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f1978c6d71f808ebef38ac0f046f2b28e437b0df2f10e375231e5d625a00bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dstask/main.go"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dstask-import"), "./cmd/dstask-import/main.go"

    bash_completion.install "completions/bash.sh" => "dstask"
    fish_completion.install "completions/completions.fish" => "dstask.fish"
    zsh_completion.install "completions/zsh.sh" => "_dstask"
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    assert_match "Brew the brew", shell_output("#{bin}/dstask show-active")
    system bin/"dstask", "done", "1"
  end
end
