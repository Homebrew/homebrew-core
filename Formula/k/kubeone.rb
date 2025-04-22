class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "19285f09a1376a5aed273eb194c09183e54a189bbd5cb508037c795d7de0802b"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f5d2aad6e3b0c41ecf17d806add66c5ab018f73537263671bf93ed78ccb386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae5ecb59f8747d30d9567a4675e8c4a35c0ac9cf44bb33d4e4e6a0738327943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "385191f7d3f8776ff6d5c864c438581ffd954b4a07f6eba06021bbf681d81c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6033965e81705d23de2b464206a48845fcdc1e07a66ffe06f9a0a971510dabe"
    sha256 cellar: :any_skip_relocation, ventura:       "aa43641df3b8e5bbb025ee6cff6a45d70ce5b994aa4e8a0a69d4e13d5a318df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2f8360539d850334fd9b14fe28a29aad16704da5a41c6c8b3ea245ee536682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e20f15b4ea34552ce781b8dc04c8139c46de03e9a2cf79c0859f2bbc4a025c6"
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
