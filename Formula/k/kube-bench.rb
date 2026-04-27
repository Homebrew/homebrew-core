class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "d9009e30081b01eb313560ee188eefa765913d4dda9b579060c09ee6f83ada75"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3842f1291b4c13a8a4e505a3351d72bc05d849e23f31d8ff3af706fb21e6993d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3842f1291b4c13a8a4e505a3351d72bc05d849e23f31d8ff3af706fb21e6993d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3842f1291b4c13a8a4e505a3351d72bc05d849e23f31d8ff3af706fb21e6993d"
    sha256 cellar: :any_skip_relocation, sonoma:        "242e66cd0040ed4e0b92c0352e2bcb24b06da417a0dfbc9f7fc1c8879cab930f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c552434e9e21c29e0d390e8f94ed6514b5b84a5d3d1f00a5c55e59dfac1cab4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f3f1123d7be31455f9d3bfd00f0aa3a639cef0e74c70ddbfc1bb39d5e63afd"
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
