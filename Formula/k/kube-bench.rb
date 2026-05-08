class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "b5aaf82cf10e542e3d85c37b0747d59447b661e70cca904a8bc224f026c1b9bc"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e2bdcb0b559dd28002eb5ca5c6450c7337d26e3751295b38cc6e7faaf649143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e2bdcb0b559dd28002eb5ca5c6450c7337d26e3751295b38cc6e7faaf649143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e2bdcb0b559dd28002eb5ca5c6450c7337d26e3751295b38cc6e7faaf649143"
    sha256 cellar: :any_skip_relocation, sonoma:        "04961fbdfb0b6b6a9b151d1a3698f6a2319cc533d834a7bc8bfb857d5fa4b512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca75b851e9ae8224bae5a2ca9f3760389008a99290b7df41cac8c131a81da597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5e444797f3b71250785d501c89c3797c7f58a22f879306100ff19776f159aa"
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
