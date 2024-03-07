class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "564d75633849ec4a6b4f75f13a637a19465fb7211a102eba9adc436b60a4f4a1"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36296f750210621ff4886257943f48564157ae0dfaa92220b0d034b33da7e717"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8d4eaa90a94c62ca4f866ffd90741379b52119e930eac9b74918638cbb1d074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f5d12b1282dbb5965b485792cd528e15c414a2c5185f836afc53d76bc03a7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c9a162d104fe816bf161f9f4186f59b8a4dbeb95e9c91acf371a4035762fa32"
    sha256 cellar: :any_skip_relocation, ventura:        "ec19598a5eb1822e3b56f51129241a7e26d784a9795b09271869a5d8e6dc8e43"
    sha256 cellar: :any_skip_relocation, monterey:       "a7355ab9dd9d67c22c09cd3604d54c6f0a021d6c990ed59da9e1e9a5c33adff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94dbd4b6d2c3948ca59fbb14a475b0053777c10f731f1f9320e71fdc639af633"
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
      system "go", "build", *std_go_args(ldflags:)
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
