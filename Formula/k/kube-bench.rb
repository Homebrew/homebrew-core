class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "30ae4e876a05f6acfe783034079a347b6748d4068ba4b7e340376e2a50d9112f"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2afbdb9a5900df8ef130ee9928debe03bfbc0b4ed65d5c55e6dce996b8332c24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afbdb9a5900df8ef130ee9928debe03bfbc0b4ed65d5c55e6dce996b8332c24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2afbdb9a5900df8ef130ee9928debe03bfbc0b4ed65d5c55e6dce996b8332c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "776d80d4a519f8ed549e16de1e8362e4762150a8675d70b6cdc64873ee5233e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df3eaf03ed2ee6145c7a617105ca8731224f0e3f2d96d353cf16f02088de0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4c7bb078169d3bc08456d37b049b38e31e9eb245ed23aeebcad62b4d8b0a51"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
