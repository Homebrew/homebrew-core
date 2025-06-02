class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.43.3.tar.gz"
  sha256 "a8ee62d92b654bec1fe22522f1a9a2d51386d9d7508bec164080083e28e99b2c"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee9582329181a6547b96c64d8d59193e522bf7b6402170b125f238d7d6c93242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9582329181a6547b96c64d8d59193e522bf7b6402170b125f238d7d6c93242"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee9582329181a6547b96c64d8d59193e522bf7b6402170b125f238d7d6c93242"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c421408b33573d6ed2c39553a1978486435033b685b16b1119e657517ad6d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "3c421408b33573d6ed2c39553a1978486435033b685b16b1119e657517ad6d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cc50ca184833089e45ea4f1692c49cff81e5b455aaccc086787154108b6bb1"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task --version")

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
