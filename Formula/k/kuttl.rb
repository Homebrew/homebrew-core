class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "e43c701f7b663ee9a88b197a9fc7b794c71452bb50a0d2ecf4fea66e0a23c0d2"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1eb2928fd65375d490e8f45a1c3104f182ce4c049b98b273fbf79e70951aa52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6abb3dd1ff7e75be6d204ee0953db366fec96dc3d6d1fc66e0094cfa191865fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8d3568c6afca2e0b2166af9902619300513ba992135d9a4b94b660a9400cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0431b174a28e7486063538b378e2ee49486d5449407e4d50be2413dc809cdbc"
    sha256 cellar: :any_skip_relocation, ventura:        "471d8aaa892d033480cd4f639d4191f875a3dfaf5a85b189f46ffd0267a0b3da"
    sha256 cellar: :any_skip_relocation, monterey:       "83afd0ad8bb867382659bc37916f046d096d0823c8f5a22c72d12e64c5acca5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9dd60a3e38f7c41d0135d509c7aa04ae14467cff3ef93e943ac23a4e54d431"
  end

  # use "go" againg after https://github.com/kudobuilder/kuttl/issues/546 is fixed and released
  depends_on "go@1.22" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.gitVersion=v#{version}
      -X #{project}/pkg/version.gitCommit=#{tap.user}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", "completion", base_name: "kubectl-kuttl")
  end

  test do
    version_output = shell_output("#{bin}/kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = Formula["kubernetes-cli"].opt_bin / "kubectl"
    assert_equal shell_output("#{kubectl} kuttl version"), version_output

    (testpath / "kuttl-test.yaml").write <<~EOS
      apiVersion: kuttl.dev/v1beta1
      kind: TestSuite
      testDirs:
      - #{testpath}
      parallel: 1
    EOS

    output = shell_output("#{kubectl} kuttl test --config #{testpath}/kuttl-test.yaml", 1)
    assert_match "running tests using configured kubeconfig", output
    assert_match "fatal error getting client: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", output
  end
end
