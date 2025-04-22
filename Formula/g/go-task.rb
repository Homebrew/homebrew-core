class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.43.2.tar.gz"
  sha256 "41ed911af61d582e2824e2ee6ac8b1a845968b09ed188e79846557226aa96bed"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a458c6fa4d2fa352082c40301a2e652c51b68172128dd6f23628b0525fd662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a458c6fa4d2fa352082c40301a2e652c51b68172128dd6f23628b0525fd662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7a458c6fa4d2fa352082c40301a2e652c51b68172128dd6f23628b0525fd662"
    sha256 cellar: :any_skip_relocation, sonoma:        "f84648545cd541ce2c0defd1531e975db8c81fba5e5e40c56f52a5c0713acd25"
    sha256 cellar: :any_skip_relocation, ventura:       "f84648545cd541ce2c0defd1531e975db8c81fba5e5e40c56f52a5c0713acd25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe31c6f7e090d745a215d049991fe277e7427f27048f19939df0689b1c100e0e"
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
