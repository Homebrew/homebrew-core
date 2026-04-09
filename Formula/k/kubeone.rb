class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "6ef2b992be6bba01b57b57f880cf3a17b3278b2f741249957be55763c00be235"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1158d6ea55c0f747ff5f2b54b7bdae9fbef2ffc8a4ff66b22bda97fd5917efb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f4cadf87724e5770a064af7131d1fb23db63e8700b5d3804f2d568a39d37d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d30b9f574542c2cef9ecdf8064c4c14e86f25735932aaa7da093b28d2964bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "41427e09361bfdae9223bd6af5db924c0917e3363f65de0aba621e4293cfa428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327d3a1613607205a64a052fd635ddfd55ae0ae3ced98d0b4844a89916365a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c53617475de2de791385dea16acfcafeabf2e94778b273c2d843f7076a1a2cfd"
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
