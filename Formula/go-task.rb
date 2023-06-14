class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "f27bb58235af96e49ab5cd9b3baec6ade0e5053b63a3c77ca7c673b0f8f3bd28"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "688b7da1c03eedbac943091b4f9e97f17a146e1353911e8e1a6683c320e37f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688b7da1c03eedbac943091b4f9e97f17a146e1353911e8e1a6683c320e37f94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "688b7da1c03eedbac943091b4f9e97f17a146e1353911e8e1a6683c320e37f94"
    sha256 cellar: :any_skip_relocation, ventura:        "67fbbbe904c5df2779ac2360ae0d2672532416f9e89bb775476c331b92330918"
    sha256 cellar: :any_skip_relocation, monterey:       "67fbbbe904c5df2779ac2360ae0d2672532416f9e89bb775476c331b92330918"
    sha256 cellar: :any_skip_relocation, big_sur:        "67fbbbe904c5df2779ac2360ae0d2672532416f9e89bb775476c331b92330918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0049f76f19ce2d61d45b352819a731f498c2c202183379793c68babfd0c0137c"
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
