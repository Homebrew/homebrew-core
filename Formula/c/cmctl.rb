class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "e4a6dc4f937742ea48b102118abd509b647bc96e82634d54db17a5d1126e169c"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d410a585723974ddfebb09c289c826491402dfc02841f3955dcac6f3551563a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f758501c1aba73c935d37b2947a64558b17152bc3327cc8cd7f84fb5ad41bf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d006383ea8bdbb29ea9d789ec4ea77ff2b4d84db88289dc49114c5411f7bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ed33eda76cbec2e3920a18e173f0984ececf7821d1858126d0c053105fb9acf"
    sha256 cellar: :any_skip_relocation, ventura:        "87c0eaf1d9604c4ef91341dfbf4b13626edbb0304b30681d16f1259cc884da40"
    sha256 cellar: :any_skip_relocation, monterey:       "96bbb0ffacbe1cb539c0948f73c732aad55a782d4f9fda26075a65f57c36dfc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c63bee441ab705ef5255f45b7a006abd2d405ceb8a7e9bbadec7563ddae241"
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
