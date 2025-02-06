class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "8a7372a5f4e65c286a879a376dfda73888f221d77b6f4f22ad1432e03375e327"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124076a5f9a715364396c7b6cd8309cd6f9fe1722fa46e9926bc07a6783ff9b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124076a5f9a715364396c7b6cd8309cd6f9fe1722fa46e9926bc07a6783ff9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "124076a5f9a715364396c7b6cd8309cd6f9fe1722fa46e9926bc07a6783ff9b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "97cdc24fc47eb7e6218f88e3633927af2add730b0a612762a1d9b2274204896b"
    sha256 cellar: :any_skip_relocation, ventura:       "97cdc24fc47eb7e6218f88e3633927af2add730b0a612762a1d9b2274204896b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6eeaa6ed0028c9a3790eb3642cb9942318763e00ad291de45ec86e0fbff484b"
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
