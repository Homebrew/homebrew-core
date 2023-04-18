class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "e1ab3c92299ad5741b8b0e9dc18593db80efaca449b8ccc318a6ff1848b44338"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39c8d378bf5e276e1961a5c7f4b2a11aecacac49fa65c1fb969a32b19beb0480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c8d378bf5e276e1961a5c7f4b2a11aecacac49fa65c1fb969a32b19beb0480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39c8d378bf5e276e1961a5c7f4b2a11aecacac49fa65c1fb969a32b19beb0480"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5a3dc463f0eb345e1b980360533fdd2ab7e1d6da2efd5c29d6523a389529bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8c5a3dc463f0eb345e1b980360533fdd2ab7e1d6da2efd5c29d6523a389529bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5a3dc463f0eb345e1b980360533fdd2ab7e1d6da2efd5c29d6523a389529bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db2ac2f9469b3913f762f59bfedb1a833f541822010e1d3ce0025bf5ea27cc05"
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
