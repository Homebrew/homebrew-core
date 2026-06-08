class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "ba68fa0541902dd8be430ef05a1a39a978d6051e99386dd64c5babc50ec1dd58"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d04c3b4caefbfbdff154a9998b980f9d14173bf717c74e1c9816ba05a9293ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04c3b4caefbfbdff154a9998b980f9d14173bf717c74e1c9816ba05a9293ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04c3b4caefbfbdff154a9998b980f9d14173bf717c74e1c9816ba05a9293ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "552a570347c21ee188ea9ec43ec959e42db72f1530cfd59475860a49afbf2936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3beefe01bb3e3a7975d3bff563b69646630f142563a06951f6e5a4eae5ee6263"
    sha256 cellar: :any,                 x86_64_linux:  "10a05abe9b0ecad14f5b78e1e80f876882a06f123f8a3b9fea3fca909f5e7cd2"
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
