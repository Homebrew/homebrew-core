class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.44.0.tar.gz"
  sha256 "9a4d91baf8fb3bfa018557f60f8516d8f8b9ee2012eaf5c1eb5d9484db429a06"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3832db54f9d84ffb0b03edfa1fa16348161e399caae10987da0d7a899a8e1b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3832db54f9d84ffb0b03edfa1fa16348161e399caae10987da0d7a899a8e1b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3832db54f9d84ffb0b03edfa1fa16348161e399caae10987da0d7a899a8e1b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7eb5db0d3e4c61ee99300d6fe53a2decf9d095e8c0591f95801e6b924a20518"
    sha256 cellar: :any_skip_relocation, ventura:       "e7eb5db0d3e4c61ee99300d6fe53a2decf9d095e8c0591f95801e6b924a20518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f50578b0eb4d5578a04e9a9f538a9ec62170bbdbf85d289d253c5a938ea9317"
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
