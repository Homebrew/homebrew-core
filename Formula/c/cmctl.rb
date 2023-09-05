class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.12.4",
      revision: "fe419511b51c162b59f8f431d7768cd7acc48678"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af73364023f681cc1c3573ed7a3565f272f75df54af0d76b585818c8e00f2360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed7803d7e99899170ef594eb504e5ab129d04274d480acde894c02b1f8e52be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c77a8a4b7200c14cfeb69321f5be6d92d52909bed5869fb5eaa4ed10e22a1757"
    sha256 cellar: :any_skip_relocation, ventura:        "e3f1069f5f19e2803d567fd780ea9a564beafae272ea0993381977ae997e5083"
    sha256 cellar: :any_skip_relocation, monterey:       "dabd56b01da3489f2619a80491943c37cc289ef447cdda86abeaaee4f6edf700"
    sha256 cellar: :any_skip_relocation, big_sur:        "acdd895948c11eb10c52347860306dff546018a87f3078d6acae8472961f15f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1740f250e12c7bcaa9abb618acf971d8f40b45b3ec55fc18e6bb1534e7171e8c"
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
