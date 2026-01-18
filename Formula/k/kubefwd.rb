class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.9.tar.gz"
  sha256 "29b8ef02f18e0b398d6aed059cc9ef59471b7f713e6616c8c64b32bfa9e630e5"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eb43f1374c306229d5ddbc72400959fe8c18af63f37424b573c8bf8fbfee06a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a02db40dc06f43e8429029eb5dfec440f6588f2efdb51584dbc6a94ae594a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab6e1308dd5250b313262759ef04a57a4a5578c344d94633fb9b33a821e3f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f573a61e90a8fb50b335b2c84a75d2829a80a2d3c2224bdf1224bd120367826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957104aecccdd6e1b7cc6494b600708ec42bc451723dd856070585c41f429a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5509b755ed102c53513827b8eaf6251f17f5d0fd247c1f7d94e2ac59cb10ab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubefwd"

    generate_completions_from_executable(bin/"kubefwd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubefwd version")
    assert_match "This program requires superuser privileges to run.", shell_output("#{bin}/kubefwd services")

    output_log = testpath/"output.log"
    pid = spawn bin/"kubefwd", "mcp", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Cannot connect to kubefwd API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
