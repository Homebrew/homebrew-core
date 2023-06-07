class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.12.1",
      revision: "3f5dbe1a5f06906b509c6c1032856612cde7f0e5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f294d8a927dd0253266b1977cd9ba12dee6ea1229e322f8dbff4dce78550425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9bec12bdc5878f60134ee733aa5bc74a080190f5bcfa7bfdabf8f20ec674234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3937366b6cd12eeca17d19b26e9abbe1caa571cd73f7f6b5a0221038439d417a"
    sha256 cellar: :any_skip_relocation, ventura:        "18415bd3ecefb8b389fb8815bb20512b6416baec238edba5c21b59adff2eeb94"
    sha256 cellar: :any_skip_relocation, monterey:       "70604c0ea5f9170f4b03def1fb3687df82735f663f9109dbb5b24b1d45c27590"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d24b8a76bf9b670f6150736c34f71f7983f644b80bb0dd40444cf183863a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180007717e69bb5f81a9c27797aae45af0c7847ab25c474a85ec960955ef5a97"
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
    # We can't make a Kuberntes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_empty shell_output("#{bin}/cmctl check api 2>&1", 1)
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
