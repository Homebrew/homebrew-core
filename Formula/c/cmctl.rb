class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.12.3",
      revision: "9479c8157dd876e2fc828850b429a4b4f734c871"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94dc21ab3d08eb5751657545dfde3ccbf286ee990a8f1b93e7546b3d868b5368"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f421251ac093a28d18bab71f66d8a5e9cb0f40470d365bf9978a8a5027fd3215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4840dcf91305d01bdfa53d52dfa01ff2e7b59ca57ef441ce7dc5f2b9ba354eae"
    sha256 cellar: :any_skip_relocation, ventura:        "e7086bfe09a0d1334dee37d0b0b27a00d93c8db828134edc601a4b27f436e70b"
    sha256 cellar: :any_skip_relocation, monterey:       "b17502dff16ff5ddba753cdf720770fbcfb7363f2dba1070adaffaad95c2c980"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf8f21a6e5edc37824235bfcbc2a48239356b280fa997ac0ff5b547510a1636e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7c13c790ca0c53ebd456afe6095030a018bad6578f675ef9dda61a8123b4f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{Utils.git_head}
    ]

    cd "cmd/ctl" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "Not ready: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~EOF
      apiVersion: cert-manager.io/v1beta1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        secretName: test
        issuerRef:
          name: test-issuer
          kind: Issuer
        commonName: example.com
    EOF

    expected_output = <<~EOF
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        creationTimestamp: null
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    EOF

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
