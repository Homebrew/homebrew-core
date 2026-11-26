class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "1c67b92fab6e495c4ba4cc3f2b12d488510b1a835c25245e8337ff8e43b2ffae"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    manifest_sha256 "6e7e94bb0349c015c90be53f8a94d9d1cc132560a7e9939d876b3391084167ab"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "512d3842254142954eee0400bdda2572255de10ee71c99908279f4fb93aa5cb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddb2d9a3e52194c96935bdafe0c63155a80fac7a433a30b3c5f64eb6604e5fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c39e00b842396ae4b6382fe9056eb6a2054a437fb84cd628cb65ae48870c1166"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1d797357dba67ae94348cd9b7267a1b04dede41cc9191f2b31fc21c86ff819b"
    sha256 cellar: :any,                 x86_64_linux:      "ee36097d82bea25c01976859e94c80bc0242875d4a49d7be26e1069e520fb9a2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
