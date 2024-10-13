class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "37516aca91af7c088e44ae2b64f409d1cb6a1060632eb47792937709f2f33344"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e80d8aba3bd45760236eec4678d6ee256a54203b7b780c13c50b03d4b7c6c9ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4d9de73913b6ce4a2d94830423bd1866abe8aa967a81ec14ef1acfe40598fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b2a1dc6f6b2d64ff7f807c9ddacc31a376a31da23f20b0dd544a8d1db995a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118d77299bc7bdb1f07832c2661b1ad56c938d51a10d4c783749ced6bdc653b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ae5e5e6dcf081f529817b9994611b592a39a1834a9be1017e56f183c50ed6a1"
    sha256 cellar: :any_skip_relocation, ventura:        "3539ce77f46c4f731801249f371529bb117e383ea7e5681a1104cc1e1c9a790b"
    sha256 cellar: :any_skip_relocation, monterey:       "98e2d75b18b7047f7baedefb5c77acc15c0de300b557fcbe503fbabe29b0ea86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb852ce6bae19d08789eb0ebaaded26e7ed1fd23aab3c51c35208e3d4745845a"
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
