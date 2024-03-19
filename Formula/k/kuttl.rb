class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl.git",
      tag:      "v0.15.0",
      revision: "f6d64c915c8dd9e2da354562c3d5c6fcf88aec2b"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c83d25ccc616968d62104bb09eb61c066b31af8b5c7a327ab0ccd7eed5b5f3c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c4fc3fe0666e60cf54ad6519f0a009c1566abd9c4bd564bed43f03449134a8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a99dffaf3b1700ea052cc4d05ade69217155ade4017f7051206eab9802442a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d243c5230366bb5df0bff7ac5727e1ca304f4afa5adab9663e0570dc32376cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b7d101464269259be36fbe92e1098f188cc31c823cb7ad70a4e965968e31d74"
    sha256 cellar: :any_skip_relocation, ventura:        "8b7dd1d7937b53bc383162f1f3c41b1e7d52e1b0293c0be410dcb06d24eb6b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "b6c9a6a13f298b8c1c7be62d77db1c50d3d025bdfd6560c6d30611fa241f3735"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e57ff14aea3c2f7e76302fe30c70c27970389173227b19be78dd2ddee03887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df65c29150f83e33447e0966532292be84bfe15a6d23ffd4ac2dde42236cc3f"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.gitVersion=v#{version}
      -X #{project}/pkg/version.gitCommit=#{Utils.git_head}
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
