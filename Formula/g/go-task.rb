class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.51.1.tar.gz"
  sha256 "ee12bd4bd445df59de17d9b4376f8afb6a623facce34169479af8b0569220034"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b93976b25adf359bad5f5cd976790a502bdac7151565871ee60235d709b46b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93976b25adf359bad5f5cd976790a502bdac7151565871ee60235d709b46b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93976b25adf359bad5f5cd976790a502bdac7151565871ee60235d709b46b8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "12aba0edc52fc4c24313886e794c9d07f540edb0aca69b977aacafbfabacfe82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665657e6f482dbad332bbc1d53a5ace1042d2a0a9b032c7704ab17953f0bad51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51acfa8c17844026ac669f0048c1916735f7a6d586c0826f190eb63e1c0a681"
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
