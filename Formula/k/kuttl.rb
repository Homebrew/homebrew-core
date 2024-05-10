class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "25d1c39852397f81f7e5098e692e37ff5f76444b447973c031e012cb8af3df92"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "850bc491d8e6b4249b72094b67863dad38b5fe35093266a03ade73e58b1a4db6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75a4e1321e1f987d1517d981f62820c67aa71669043e0bf3d5e5aa2581a88eb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd6dabcd60f8be00f22cbd4b3937e49becd7767d5c0ec45046c5d37bff71e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "93cd1aa1100a63a12ecfde013d0026d639a22809b72e7947d54e22c29cc44031"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7d1eab4dc04bbef3f98d3309d5ee265cd1cb8aa8e740c50f46d6cc52d20f41"
    sha256 cellar: :any_skip_relocation, monterey:       "01ed67a7debfe7e233cfa8a510e924871250b0b95076033118f9d22be3c6f8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c5049d6497ea2171c41a7dcb350beb5ad5d611b3c280b0fc485753ae65f57e"
  end

  depends_on "go" => :build
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
    if build.stable?
      assert_match version.to_s, version_output
      assert_match stable.specs[:revision].to_s, version_output
    end

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
