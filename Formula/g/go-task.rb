class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.45.4.tar.gz"
  sha256 "bca35c6d394be1c67422bb7aae9b1fc2cb83143a8a1d28f032388f1d926d3311"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0874b8687f2653d1e92e0c4352089df2327b7b4b9798d174e5958b148c4fb99a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0874b8687f2653d1e92e0c4352089df2327b7b4b9798d174e5958b148c4fb99a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0874b8687f2653d1e92e0c4352089df2327b7b4b9798d174e5958b148c4fb99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59157076990f687c6f97c2382537ff0e5ad8d133041c4193e840976d0e78634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddd46e97f33014d88204cae04f6d64a16c945bee44a77af2a527b0839e28cea"
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
