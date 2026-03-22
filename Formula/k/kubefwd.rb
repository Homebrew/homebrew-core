class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.12.tar.gz"
  sha256 "e5b87adb45441cdca29b40fbf38adc257c496a7dd3ef644e9bc0bc8a7aa255d7"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19e63fdd7f9f9bce2dcb919db5eb39f5a162cfd3f8e11ca0fb83aa7e0964e570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3819725ecffb09bee821f8c8f5a1710de17be6ef2fcf9a3b5c32c8369c7a7f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ccde2c656a0c62af721541f51527c13aad371394743c55595717d32d25b91d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3713585eb31120c3d5af702c4a1a7c64e3bd93e7e119022548a8de4f53bdd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0712b4d0f7d6f29aa4f2a1f0963189e28e5ebdb0bfda8972d77ed4d2de014bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a5c0d0697b4efa5a8303e4abbbc1d4ace4cf684ca2122c24ac3971c477358f"
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
