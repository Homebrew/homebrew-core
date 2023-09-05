class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.29.1.tar.gz"
  sha256 "689cd24f2e6af6459bed95f634ab8b50a2344a4f097e69ff1df7027bbc493cfa"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22513c187a6428e4df3c596475bcc6f957ea429efebd393903e1f62452183795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "508b039fff2f24d22acf9b6e8753e86f05b6cf7c163e0b316c73eeaba160c736"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed4cf1d78c00c2d4fc6d1effb141881ad460de56064e74df797f960f53a8a32"
    sha256 cellar: :any_skip_relocation, ventura:        "c1adbdacd0bd40fca082735dbc8120ed51d865d8e00933d50d745121c74fece9"
    sha256 cellar: :any_skip_relocation, monterey:       "6ace3928a44c40170c05492349569435e7e539a6fe94aed0121995b46a101b87"
    sha256 cellar: :any_skip_relocation, big_sur:        "236a4a96dc73e0805a31648028e6b785c67e26f86e965d26ad2c2c451fdebeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c24ce1988e0f010d53f76519a3368adb04aa0f0517b133d108e2b291f5ae23b"
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
