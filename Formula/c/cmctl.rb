class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f2bf7e2a14c6df8e8e2f0db3cb4f823f6efb4c83830daddc30a04ba84bbec308"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3763898e4052a02acd7ac6e34d202be32d3e1d19eeaefcb21f41edef8fe2e7e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db936289d395ba64420047543a9b6ce28723f5f105cbe09696ea1a02760a1d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2840292dc90ae29acd2f5e5c32f97fdf465b2eb452c248f31a74c1c1b79c62d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b22e3483206db05165f6bc2f94b139086ec940f278f9a2b324bbf591ed799c0"
    sha256 cellar: :any_skip_relocation, ventura:        "5bbdd05d0a0ec426254141c92842cc2d8bebbaec731af29f6ff081a0eed666a8"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3e20cfd5c915f404b2f4b82f351b3c6e7d4795f7bcf19e95bfab74953829fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dee7c650ed318b051cfc304c8a7575768c34ea985603354c5d63c62c14eaee5"
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
