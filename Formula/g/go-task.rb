class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.37.2.tar.gz"
  sha256 "ed735d663527691d53e44af98d24b3df91fa9da96ff6e05e9b6c7b78cc05c913"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "284f0a955a7744d551a0d88043b453e572443ff5a42902ee9a3db0ab52503b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33b0c604bcb4e2ea28a03b735c17bb06e60a31c3b2bb06da422d166af6ace153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1640eef61031ed240c273445703946783d004631a7f75602aa068dd976ca739"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a570e4ab6ca9434e782f699629e691b15633fd00b03ba2cce49eacaa30848e"
    sha256 cellar: :any_skip_relocation, ventura:        "e318dfce734136ba0af673a34732266313c4f11fdda4bf83bd1c9e04a3932124"
    sha256 cellar: :any_skip_relocation, monterey:       "5651c57be532ca1e0475f7c4b62576d538ac68a11cfd8c306342d6ade6de27ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087edcadb79e35a34754afa7281a4202c0a80df916b2fccf1afdec9cc2753d04"
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
