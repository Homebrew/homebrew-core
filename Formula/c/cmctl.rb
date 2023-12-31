class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "e6d9cdd2e6aab45498e2a179b075caf52b0f4acf27a7ef60c0ce933bce346388"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4946c331b1a3a7808afa78cfb9588b2ce161b20becdc01886121b8494b117dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a632e5a7f2c4cfc2508e4068ddc1405a936f5afb723959611fb3543e9da6789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "680bd096de822cd2984d53f1c11c11d4572f68cda482dac5b2d4f16aca5566f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c4b3e292589bac24e8c8d50cfb6aa0615482c0b2eaed2aca55e923b97129e25"
    sha256 cellar: :any_skip_relocation, ventura:        "67f029f00b8763b095a564c9baf2106a7f2b145afc637c0059b1ab5866b32bae"
    sha256 cellar: :any_skip_relocation, monterey:       "a9eee34fb2bbeb1afd92098daa21be574444b1bbb6ab5bb4442a5d33d7f24816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd53275b399083a8f9dc5fd069a8301238f64a84d3fa1a9e5747ce758e44c54c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
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
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
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
