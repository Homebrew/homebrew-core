class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.49.1.tar.gz"
  sha256 "d33760a91de1369799b57ee0672b9440067fb27072c75046ecba239025777f9a"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "880021153684b9aa381534d8ecc7edcf500f13c3ca290b771af1e882aadee5a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880021153684b9aa381534d8ecc7edcf500f13c3ca290b771af1e882aadee5a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880021153684b9aa381534d8ecc7edcf500f13c3ca290b771af1e882aadee5a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "70502540f4bb6198d4f61460d19e0935c7283bcb06eeee413957fda8f508e0fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c2bd1817ff97bd83e4087f605c3628af4ef74bdc584ea85deadb9edb4f0975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f343ee66c70581bd74f66118580d9c4c4a952a260f81833ac72534db8289d0"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task --version")

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
