class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "9efea45f97200aeda004c3d05562af39ddb62e851532866f78aea4bb1e097191"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d00a55f57e288a23fad937f287fe6148b342d8f5bd76265f4982d78816c8ce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90c1f9f6302fe661267a2458c958f3081e6fcec4155de173339dcce2264725a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8ac6e14888d19ad603837871b1d9ee69c2d1f83c8216d334f0a5bbb9271bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b602d32df5cd68264c64d5b25b064c81631648d297ff6d1fc7c78e58add538a"
    sha256 cellar: :any_skip_relocation, sonoma:        "46defde781f30ecb8b0b2015f1a106781791b80ae42945d862ed245a030835da"
    sha256 cellar: :any_skip_relocation, ventura:       "eebe7b4157fb8403b82e2cea6663fd45bb7c8db6d4c4016a904814c5980db2aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e5fbf540c9d45a0b0e140a1377c449580a61906dfb7497120476bd0041b7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36cb58134ecb7118cf084a87b2ebc5ff9d14b402172a47bf23854106aae5a992"
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
