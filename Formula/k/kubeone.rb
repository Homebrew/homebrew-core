class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "ca2984a054b6953b2f5502594210ef54356953277391b8e9f56f21acebb93873"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee1abf88929b73fc167bf9bd88c422efac828296cde9ca208f4dacd45bd9d2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0016e7a8b56375e2264d8589a8e64eafa109e375a5b1978e82ef7ed26bd53d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8318c486f7f5eb7ec9a2ea24dc0a56fd2887ca3b94182c02ce02ef3bffa4a0eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "329d7d867144a8ec5ead858768d7fa5e92b9fc0ae01526b0686f1f3f0e22ff3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3d98af21d5088f4f2ff07ac19bb318bd3813768b8c28c4ea97956d3bc3f4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07f27a7e008e0021ee289c24576d28a8cd3abfbbe41a32ae1795dacc2e3d94d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end
