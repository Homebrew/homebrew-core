class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "7d9e894863998800a57cc5045a62dd5b7e958951347f172a96aea0907f200b19"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f5fe779d3aaa2fe518a5a6a34a92d36993bb157f60848307d511194a5f443a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f5fe779d3aaa2fe518a5a6a34a92d36993bb157f60848307d511194a5f443a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f5fe779d3aaa2fe518a5a6a34a92d36993bb157f60848307d511194a5f443a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eca0d5815a129efa69b75b756fdd554adcc6d85618110d83c5187ff60b2f837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2355e2d2cffbfab948499fa1a3c3d759becdd035cdd1dde35de0f66e012d55b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0883040ac4a1ae9a6c84a7dc6f76a92b801e5e619ecde4de77be1b3adb56d0"
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
