class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "4a550aad41704a80dda2efcc064e82ab85163e2f805689a417027cf52f6a29a6"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdc0532b1ee1b53b0f69ce937ea3ffb48ac4f1da71790958e655ef9e15b728a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc0532b1ee1b53b0f69ce937ea3ffb48ac4f1da71790958e655ef9e15b728a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdc0532b1ee1b53b0f69ce937ea3ffb48ac4f1da71790958e655ef9e15b728a2"
    sha256 cellar: :any_skip_relocation, ventura:        "0f64c597f53b7dce9e593f68ad9c47cf1baf239fbaa03c16040fab5a4dd710d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0f64c597f53b7dce9e593f68ad9c47cf1baf239fbaa03c16040fab5a4dd710d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f64c597f53b7dce9e593f68ad9c47cf1baf239fbaa03c16040fab5a4dd710d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e834c474f184ca74546abfd85e507a3ee63bbdcbf188ace455c61dd8f58cbdd"
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
