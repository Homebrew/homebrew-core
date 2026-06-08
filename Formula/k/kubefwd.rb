class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.15.tar.gz"
  sha256 "a4e446ab5f5c9eb3e11d4f682961c194d478c7dfe5c64d4d5162a054b0843043"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b25099ae6c7bac8155f2929ce2e6f3e39e819f48fcb62af9af17100735ea98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e378498281143dc34d1e26c5fd6248624d2bd72b8a77bf99b4c6eaadc0fd1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e40880a0067a0c2cc9f85778091d39bedac493987658aa710cc5633c3f6a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df1878e01735eafaf173adccdcfe89c28db2092ea9280313b5b60601a647304f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e5373d45ea5e334092e9ca9f6e5e3c81958376b17077bca7f38f3d4c7b43bc6"
    sha256 cellar: :any,                 x86_64_linux:  "62a9451e1b8d4ef3bb456b0754823c7349c1f1b49c7f8db588f7ac219fa70266"
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
