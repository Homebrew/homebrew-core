class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.11.1",
      revision: "e3a2a803e8ed7f8a88d5f535d6e9a061c1571194"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80b3aea65af325a04b3314bb16295ef07cb0e78c57560194154e970f4f5b5a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d438e23281a97bb2aeb1541b4fcc3f1c34edb4256f05f7a83ab6f6c0df99097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99830c791ab34469c8fe46db6573b2b8ef148ff4005944a6791997c268919e09"
    sha256 cellar: :any_skip_relocation, ventura:        "524dfda3f2adb9fc6f59bd7574183e9b5cc31f2c15aca89752b4954651cf5259"
    sha256 cellar: :any_skip_relocation, monterey:       "a11df920b2d5869e7bae9ea4e6d03082956b038735325fc1febbba3d4c0cca00"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe69b6133aa6615c9560c73b9f5deeb1f087491a8d38227bed0db6788f625ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb55d65432fa5591867e7b809fc64105cf87c73c51dc1db71ccf4a9f9908d59"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctl"
    generate_completions_from_executable(bin/"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kuberntes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "connect: connection refused", shell_output("#{bin}/cmctl check api 2>&1", 1)
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
