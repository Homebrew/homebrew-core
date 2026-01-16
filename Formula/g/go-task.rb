class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.46.4.tar.gz"
  sha256 "a39cec5f03178145a440668bef4f4e63830664ac9d6a86fd28c8e1561812ad33"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2df275012392e7c2fe3c16d31cf34ec9f2e70bc9a2c3a22b7d09e3b37febc85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df275012392e7c2fe3c16d31cf34ec9f2e70bc9a2c3a22b7d09e3b37febc85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df275012392e7c2fe3c16d31cf34ec9f2e70bc9a2c3a22b7d09e3b37febc85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0c8db607473203cc3ccaa9e2d81624112fe47ca508c79cea40f8e51d336334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7207817aa595459cc9b7f373e9c055e1b00141989712273c8fddcbd796196160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e5316e17aa299c3b852dd0a488e716119cd10d009dfdd4d2b005c6fbf65e3e"
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
