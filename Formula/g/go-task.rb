class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.48.0.tar.gz"
  sha256 "41784e166ef1a6bf429829195a727345296dd9fb94d59a274f2e158383167753"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "328d885e406c56dfa8d89a909b4febf592ff22850acf4e68394f92e4317582dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328d885e406c56dfa8d89a909b4febf592ff22850acf4e68394f92e4317582dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328d885e406c56dfa8d89a909b4febf592ff22850acf4e68394f92e4317582dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccae21c25fe047925191d87f26b2d0578489a2697b96591b041ab8f010a67058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3b8e759e87d9d1c8094e3741825005a0934981546390d2325feddc4eb53eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76154811a8827f0c84259fa70c311fbc6c785569af46bae786a6ece2fa3f5ac6"
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
