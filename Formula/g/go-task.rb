class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.35.0.tar.gz"
  sha256 "ca9a0646c01dcfe414a6244385cae355d092d0fa507ca7fe72efc3b7df03032f"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffb483cad02a65fd77865ee6c01913c41c78b1adeaecdd559fb976453329f5d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a2127c24b2c037dcd2e004311e4992f27b22e75b5c2d44c5c5221b2832f42a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18efe4556d87a42a9d2c4ff0c19c9ee79bdf006e9649b5509f17affd0abe9590"
    sha256 cellar: :any_skip_relocation, sonoma:         "12c4f5383f19c004ce62a0048cfeb1aa23334414204046d3b40b9aaa9b087f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "c3284a5bc16060ff2784531264925f2899d946ad51032fe88f0a9cc81caa44c2"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ddd76b4644290762b16d7b032bf7c52dd018d03d03a084900b39b95beb6d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e54be3d48eece7658863d72c408c97184357c3abb3b091911e9a2258c56ebaf"
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
