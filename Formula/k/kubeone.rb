class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "90d3e7d8fb6723a9f96c4d30977dcbd411bf5a30ddb9946ebdcd22c6bfc68272"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c04bab2258e8bf5b7fd9a2e243fbeed5d5993d0a3d072c07b7340a2a42294dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157adfa00ca730818c21fb7f54cce3e938b909aeef8c42b304bf28bd20571fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311b125bf81f70d133d487a3c655e23ce1e35ce6cbc2da180ec039ecaccf5c7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "07267a77c6f118a9a5ff9609ec575432ab07d944f251baec5ac995f13c72d9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e4ae3a77994a20458ee2a0fb22b018e2d23ce9bc615bfb4cf621313fe99b077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f006252c6c6057d4a99238f7c68adaa3be82c1aadc7b68ed2c111f143fc254"
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
