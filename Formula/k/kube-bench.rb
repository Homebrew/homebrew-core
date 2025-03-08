class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "366b82870cd8d96355b94738cc9024041b5d4ff21507f7605b7ee031d5b1e928"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268deafb11b1779d0b0a9d72d448ccb704573015d647efbde906d8f9bc78fca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268deafb11b1779d0b0a9d72d448ccb704573015d647efbde906d8f9bc78fca5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268deafb11b1779d0b0a9d72d448ccb704573015d647efbde906d8f9bc78fca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae047c8ac58e5dff38abaa7af2c48edcabd090841b789df0dbec8e6c2f14bcf1"
    sha256 cellar: :any_skip_relocation, ventura:       "ae047c8ac58e5dff38abaa7af2c48edcabd090841b789df0dbec8e6c2f14bcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5677f21e41032bdead4061be64a8ada726e8d82e71f03bb2a8d5f58b943def"
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
