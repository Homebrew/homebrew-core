class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.14.tar.gz"
  sha256 "6b44f9e7d0280c5d181130a0e1d2e54b2b60dbc521d468917becbb53deefb869"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01fcec076c3a35ddfae21d85e14e873dfb69a64a5b488e653783ceeacced8a8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df44b82c1bcf10af395577140ada5b5e4aa7c15a1021a6ee796a65ff6ce1268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b53025c97080859c135023c770601a639190551154632b0dbb79d6d8f9045e"
    sha256 cellar: :any_skip_relocation, sonoma:        "69719ec939e51cd04524efe46e9ab254d5cff89bbe34dacacbfff489d2a2014d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d24469bb2f0a2111f32cb16f5375e66ba3f402d511ecf4f61864fdb11b6aaaab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9522f0b549854c42c5d7db91ed46cad333fbb576ea521554e2797a8f47a0346"
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
