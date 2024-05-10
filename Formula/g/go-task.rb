class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.37.1.tar.gz"
  sha256 "5bcb053843c4ad34aa509cde67e29d97afcddfbe5bfc60f7dcb299d144f0f950"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baaf57095a4d7f33f685294a9d8374206d09dee5555a0858f16f85a9fedcf814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "907658246e0ba6ac4c615b3af453730bbb4cf7a78828d8d7d639af466dc6cb07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d858fe45f1fffcf02cd5f8a3911c3e15ce8b220930ac39d8679ac5a684936a"
    sha256 cellar: :any_skip_relocation, sonoma:         "57f309ab4872fae3e29ced7c8405d0fef36d78e17ceefd760927737914334c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca1a0b13ac245cf46209c8ee47b0bd932f6bced2ccdfef9950308fb879da52f"
    sha256 cellar: :any_skip_relocation, monterey:       "e2bc28942a5737946e69a200739176cd89c1d042ae12ce62acca45d38d762b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6410b6e4a9d532f884363645be680912c5ed57baa728f1ddcd07a714319ced3e"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
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
