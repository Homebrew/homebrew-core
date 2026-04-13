class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "d7a4196b228f6fbb929f673b7348bb905a15809380d41ba0d73c5af96e9d8ad7"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c2cb9eb89b74c150ec01418799a4caf6d5bc452cbe5ddde13fce7759b7de741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f002c2cba194b7415a71d1e28b6af919bd358bcfeb57e34bdc5961938f2b0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8a597e963ddc35c158b5a022192b5b75f98b27758495104ea8fb07b996a287"
    sha256 cellar: :any_skip_relocation, sonoma:        "4541f2baf910a07ac8a269be81a0edb9838e7cb1828d92ceb9da09e099b3fc89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227e8a0d062893f0e2c9ebad50689a68882252b9b6de13a013f5d6c87ec1c4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97ab73db225d6451b4fe5c92d394d090b40eb4c78b2a664be2c83170440e505"
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
