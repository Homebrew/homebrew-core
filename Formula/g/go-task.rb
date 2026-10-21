class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.54.0.tar.gz"
  sha256 "d9e92770c2c18f135701431d04bb24fb77b5f13464699683892bdfc0b26f2eb8"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bd590c63c6dfa71ecbed3e2ea2b56ce10585caafe5e64c701b47bd545af8425"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bd590c63c6dfa71ecbed3e2ea2b56ce10585caafe5e64c701b47bd545af8425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bd590c63c6dfa71ecbed3e2ea2b56ce10585caafe5e64c701b47bd545af8425"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "acfd05df69c800900801274cf19dd94ab61fc72e53e9bb22bde4e7bed294b070"
    sha256 cellar: :any,                 x86_64_linux:      "0fcf16162746728079ad400786ba0a98dd1f44864947f6c59c0af0b4b5476d38"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task"
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
