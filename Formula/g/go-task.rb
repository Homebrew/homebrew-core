class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.52.0.tar.gz"
  sha256 "54833f32465c45d222867cc89c6bc138d07c63d2b43f0512e2cdb4b2164ad87e"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa6e267bc790b90c19eec4e7f5a72e7b4014d70489737907bccee95f98ba934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa6e267bc790b90c19eec4e7f5a72e7b4014d70489737907bccee95f98ba934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa6e267bc790b90c19eec4e7f5a72e7b4014d70489737907bccee95f98ba934"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f8b55ef28bb2532c2207ae061c2ed1d74a0f930bc72076f9d70fb575c020be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b45708c1045ae8ed54a18a0d6f3297a746ca0a73ff8ee367283f211b252ea4"
    sha256 cellar: :any,                 x86_64_linux:  "2b572eb29dcd078f580c3bfa08a7a3c8d317bd3deffa3b1dbd5c0da5b324767b"
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
