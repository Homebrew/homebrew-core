class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "7e37ae9a0a6d08851ab02a72bd42f212d9f2f2128b4d379cea2dfca64dbffab5"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf918e555371d129c48cbe90f0535cae1c0f5b270a14ccac02e207146dc018f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf918e555371d129c48cbe90f0535cae1c0f5b270a14ccac02e207146dc018f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf918e555371d129c48cbe90f0535cae1c0f5b270a14ccac02e207146dc018f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "972bd25028baae2da8cbafb813a2d9727811068ed9389969e933098615c57919"
    sha256 cellar: :any_skip_relocation, ventura:       "972bd25028baae2da8cbafb813a2d9727811068ed9389969e933098615c57919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ffd6ea2ecb3820e3e5611264e1bd01945cb002285756ef2d32ca4a8531f9f78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
