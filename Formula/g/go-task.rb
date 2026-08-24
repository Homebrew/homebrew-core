class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.53.1.tar.gz"
  sha256 "dd22395f4548ba58bc3adf83cb9ce33f1c5fad7e7c5f0a229bb2709af439fa9a"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "256f64599187c98918e3358555c9917d2ba3fc24b64e7cfea1ef93ebfe682442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256f64599187c98918e3358555c9917d2ba3fc24b64e7cfea1ef93ebfe682442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256f64599187c98918e3358555c9917d2ba3fc24b64e7cfea1ef93ebfe682442"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f12db57cc70597ef669c911ce3515d0612da37c9b0069331f2de23f85ad1af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c6e269eec92ea2870266e9e2deff42f7d1dd16c0adb5efa8a17fcf97077d53"
    sha256 cellar: :any,                 x86_64_linux:  "fca26b81d8aaf1e98294ba86189badaf5683198d09a0535cfe7496df63d5797f"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
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
