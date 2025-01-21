class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.41.0.tar.gz"
  sha256 "18302d17d660b25d388338765664e4f66853f10d6ab9a5f2285e56f30a077976"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6963214ac6da799bed119b37a7aa5ecb46d6a1afadd1b2a25a531cc9cdd4310"
    sha256 cellar: :any_skip_relocation, ventura:       "d6963214ac6da799bed119b37a7aa5ecb46d6a1afadd1b2a25a531cc9cdd4310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db129a42a74db2751a677dd62b414629db65d7882c65b8c795ca2c08e1db7de1"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    output = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", output

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
