class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.36.0.tar.gz"
  sha256 "ba286bf87a82a284ccd8a76a828fa07269bdde377a4f6770bb5f2bea35bd8522"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebd794e1f5d4560182d7b353c189d3ed5b69fdcf993fbbd3a72946aa6d29f189"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9fb82f7dfbfbc5c82a4c099774531795cc589dc3ec977fa7a7e0004b4711650"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c92b6efa45ff208de7cf4ab8f6026c9780ba94179edc1576fa81ebf37d83bdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2780afe4461639d361b33ca5b9e0f17f77fde2dd8ef46490fe9f6950f3e60cf"
    sha256 cellar: :any_skip_relocation, ventura:        "12f119f17aa3f527175052bd428e5208a56ac76ba6627681d7a98ad7f44c5a73"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc1d1f4314444d4f27d91b3c46fd0a89abc5a22571845e24d119d651ad98331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75193163f4e4798e34719716d14a1bb055ae55f4162cc49d0a00e0adbdf007f6"
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
