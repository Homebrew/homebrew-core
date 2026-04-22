class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.50.0.tar.gz"
  sha256 "d026cc8b9a766d623b8d42ae83986268cb2af91927d0ec66015e4053292dce88"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c705f4c0e586bfda98693e16940c699ab0447e29b8aa6026eae856811963275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c705f4c0e586bfda98693e16940c699ab0447e29b8aa6026eae856811963275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c705f4c0e586bfda98693e16940c699ab0447e29b8aa6026eae856811963275"
    sha256 cellar: :any_skip_relocation, sonoma:        "905699279e4b26636e682ca5c14d387dc3ca795db895d921b9ada81300013b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "491e03123c153d3e974b5476255fa0dd03f3356c8e82b370af2494b764ed2185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5428f0414cb8dcd90e788e09eec572272432bb970dc6dc93964c7c1b3af27f4"
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
