class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5d2688fc0c78e4a2eedf5f095e67a8ad85705bf442ac7b67312af75a73a3801c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc8245aed689e3e0e3dd8fcdde3adbf11498309bc67f4aa1331a368d343bf579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8245aed689e3e0e3dd8fcdde3adbf11498309bc67f4aa1331a368d343bf579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8245aed689e3e0e3dd8fcdde3adbf11498309bc67f4aa1331a368d343bf579"
    sha256 cellar: :any_skip_relocation, sonoma:        "875a28f07dacf2e02540368a29978b925bc505a9602ce84e26529e0e01ef2227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b4e66138c7882ed5a41838bae9560625782262834c88e8e185281e83e368f3"
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
