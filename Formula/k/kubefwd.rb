class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.16.tar.gz"
  sha256 "a7e34e676dbbfaf97eb133e5601167479f668c777b653a86f267810d3729f9ea"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03b4c0abcdcdbba9c9513de33db8d9411b87255f5f51e8dd4750363e788abaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def37f7010ee0eb33b9a6fd4589b361f6b11755c197a982f64e5de617e0cfe0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d05159898027893105e4c434814093ddc934da790bc7b0a655bc7f2559e8f692"
    sha256 cellar: :any_skip_relocation, sonoma:        "69881e63f0fc066cbae71dafaa3f2353812b64309ab99bd269cf6d00c26e5770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b0d4766c58dfecfaae582020993a7c6e7de43567f9a9b9c7c4180ec8e3916fd"
    sha256 cellar: :any,                 x86_64_linux:  "4935c0b2d84939aef47a7c5970ca584969fac36d5801d7ce1b0222a33507fe84"
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
