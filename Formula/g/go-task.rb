class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.30.1.tar.gz"
  sha256 "2ea7ade74a7007766412d905fbbff91676ee2e4fa5af0e615dfa6c8bd843482c"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49e9267245c37d7f1591142333f12f17976eadd74326fb52056afa9fa7e9c0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2598123fa18cfded604f8d3b167ec0af42422202155bdffb8113ee916227eea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a441d984ce9b2d3d31e2dd2a100775359167aab9efcbc55d2a344a0b4321380"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c49baf0899dc9e28934922ebdba8440e312e4e8711e0fdf3477aa0661d92b8b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2f658cee1396cfc331a2e775eb637542647c197bb60c3d1bea9eaf8ddb32263"
    sha256 cellar: :any_skip_relocation, ventura:        "ac38572a44e4cfb2a7c801c2e4042e20e32d208da97c88e8e8007585418d5592"
    sha256 cellar: :any_skip_relocation, monterey:       "43e376ba4ae9747980caf0adf6586711797d94596bd3d101a48001e8329776fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb5384e348216512ed69b1184f332bb2ace3b0890fa4eae48d2a31a19f8b8473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65558bf2394c4d6f12c5ae69432231209009a120179cfcd637949d69ede6aa27"
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
