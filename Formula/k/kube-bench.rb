class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "41fb9a5db1030439270a6a969da49cccb5149bd760fa478c0ca8757d0ef7bcce"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54137041c8f63712c87feaf9419da2676babe0c4adbe26be272685166dd992c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54137041c8f63712c87feaf9419da2676babe0c4adbe26be272685166dd992c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54137041c8f63712c87feaf9419da2676babe0c4adbe26be272685166dd992c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3704dd31bb67c43ca5efe1beace4e37301698e32a42d0c3a827f8bcaf850a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4676363ac4624e562dc7194f0b083d173dddb8dfd0209834e8b8afa6e7e6dc90"
    sha256 cellar: :any,                 x86_64_linux:  "529e7bc8af2cc5cea42e0096e70a15ddf9dca4da10ebe7110f2af504e1e85a40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
