class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.31.0.tar.gz"
  sha256 "189f3b98ed6b15290d4fd4dbab687c87de268b5c9f2f1c93a7c02710da062785"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d327c01d4a4bb2e1e2a19fe32c8dfda75ba06fb80c6864477e4b711058d2b35c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d978afedb3bf8d2ce5ee3be8f10119bbba1489d4038c68d07f1ffa29339438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acaed4b0e24f87f21ac0fbc8624e159786b6f750d56df68c253ea5ef1c152dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "eea42dec0aba652ffdfac3918fa6131bdbea2fa8685c82fb1725d4d738d14e13"
    sha256 cellar: :any_skip_relocation, ventura:        "1a205a199d649e8ae377410c5a200406e4f3bee86626a1567eb7cec7b2d93120"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e454c7402c9ae21e606b295ab79cbb3676931ccd5e325b8fd6dd4b48281022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76efff3dac4c3e39b48874facf443dcacff428dc222b3beb44baeeebe737ce74"
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
