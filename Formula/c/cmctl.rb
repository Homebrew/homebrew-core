class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "70c9f5e1fbcf526c87c5a862afca663b816e3ec1eda2d55c7edf70e33fb00fe5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "291b511a8c5fa486f5cf94358527770d4f0307563b221425a64c0a9a2c06a63d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc1d5ac986e39da4fa61785b9ce49db17292a37b61957d94e0fa25ce80bb174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b27b55bc9fdc8f36c7e7dd57412dd18959bfafb4e1910b793145129cce0a6646"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61491c8f73e2de22532677e52eb0987cf27a3a2b95ba5298c2a2984d29a8fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0970ba25aa60ad39e6546b58f92e7a90e15def9ac788c700f6fa19eb074a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2648686a59c1ddaebd2b738b36e4ded146c5ff7e1393ec3f84c20b8acdb4f379"
  end

  depends_on "go" => :build

  def install
    project = "github.com/cert-manager/cmctl/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/build.name=cmctl
      -X #{project}/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cmctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~YAML
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
    YAML

    expected_output = <<~YAML
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    YAML

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
