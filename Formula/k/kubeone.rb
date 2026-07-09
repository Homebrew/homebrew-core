class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "72011cf2f32ac03c38c1bd0d952d0db0f1cb01552ad523b3c9ee267991117a4c"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06933354b47fed3f13e8cc4bb635313e066e645fd898427c569067599f4f26ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71fd211ff4b1c1bcef5309315aa0f016649a24f947cdf9808bfa896c81795a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c3866db5bc5bf41f0c12425172212d3fcd31f98582ca3572d1fc914fbcc75a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "313fba9a4a22ab50e5f760e0fd50fa9bc66de39a117e1b99affff20124c9967b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a54f2cc7248f98db56dc4b140e39c1f752d2ec476314859ee48b58682bb813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f3ea16b807f87dd2663f660e7d7c81f8f079b32aa87f6aabcfe4934c80f5549"
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
