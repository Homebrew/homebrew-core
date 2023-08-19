class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "3627c72b9a8f21568793e6d9b74646c61fb23a55fe2abed285194f37f21c39ff"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af77641174253e9f36179836fa2ae2ad6fc0efe0b13afd366d4a6bbb6d3c6cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af77641174253e9f36179836fa2ae2ad6fc0efe0b13afd366d4a6bbb6d3c6cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af77641174253e9f36179836fa2ae2ad6fc0efe0b13afd366d4a6bbb6d3c6cac"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b2d28d202bb559b7b244327324735a8ca21b23e0fd6489557691cbcc1ed6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b2d28d202bb559b7b244327324735a8ca21b23e0fd6489557691cbcc1ed6d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b2d28d202bb559b7b244327324735a8ca21b23e0fd6489557691cbcc1ed6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7e69e959d9dafb4004c92e0f6b226a4703b044bbef6786e3d1da18fc04d34d"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    str_version = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath/"Taskfile.yml"
    taskfile.write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    args = %W[
      --taskfile #{taskfile}
      --silent
    ].join(" ")

    ok_test = shell_output("#{bin}/task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end
