class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.12.2",
      revision: "a662045c2a7ec0d9118176965028113230fa9735"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edf43d262cfd080ee98f6851c6d84928c77a85a005118036fe9cd47342cb7e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d67399b9896035eb28f065dcdaac0002de86ccc3a82a3c79d1a0b45aad3ad4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fb0b2881b7d8238a6c8dd93749260c13f26643c074c5efbb243c224efc8f818"
    sha256 cellar: :any_skip_relocation, ventura:        "667e69177a89f2d68408f8d9f9dc9fe46c8835045a652f5f8653a1791ac53197"
    sha256 cellar: :any_skip_relocation, monterey:       "7bb6734bef6e5de077b06c37893b0508e6090a3352c47c4899bc6422300e2432"
    sha256 cellar: :any_skip_relocation, big_sur:        "318c7dac1ca202e3e18a412a73368d4c07de7c644853a0c50fe467e57c45354c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc1616c0cb3c90136425bf7f56c086508f69f77987ddb42ad107afccbeda3ed"
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
