class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "9abe03f06bac507bc8a153bd94ccbe5cde324ee120da7d596b1845ae4e8e3d53"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528f6f6e8c482aa77b987fa515634fcfcf8c8f767f2b8e5f1ccbdae1d0eac796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528f6f6e8c482aa77b987fa515634fcfcf8c8f767f2b8e5f1ccbdae1d0eac796"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "528f6f6e8c482aa77b987fa515634fcfcf8c8f767f2b8e5f1ccbdae1d0eac796"
    sha256 cellar: :any_skip_relocation, ventura:        "67c0d32d69083528c468d9d51b5e7d992b9c7c7dd16fb52e6769d6a1609e8d63"
    sha256 cellar: :any_skip_relocation, monterey:       "67c0d32d69083528c468d9d51b5e7d992b9c7c7dd16fb52e6769d6a1609e8d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "67c0d32d69083528c468d9d51b5e7d992b9c7c7dd16fb52e6769d6a1609e8d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc618c10aced94093d5116c3dc27c8f34541880371d47de250f1b47098a78420"
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
