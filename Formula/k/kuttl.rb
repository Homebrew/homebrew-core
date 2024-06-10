class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "a9a3a0aea4d6954855b53c7b033996ccb2a60cc09ed6e49ca17d1aaf73a7092a"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01be77011aa2709aaca437ea6d1dcc24fc9d626ac800878b116b953b7149d16b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1a0a0a2adabefcc39f69066e02e3829d6d45e3e59a1179510281d0ae0d73215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04621991072d889d6a6ee12c0d78d9c1e7b9eec4d4f67891ebaaeb835cf9600"
    sha256 cellar: :any_skip_relocation, sonoma:         "23e31d4b93abc256c0be48ed50b633508f42c2a6ac6913ae9deea756250ec3d7"
    sha256 cellar: :any_skip_relocation, ventura:        "6c588e4ee59f539beb0099eed7d18feb764bcb01e8290d83d98addf17e9ca1fb"
    sha256 cellar: :any_skip_relocation, monterey:       "cf61cb85592e5f1cf567f04b3e7ba7399d4a206a829059ceca82cc81b4fe6278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4106a1c1d66a6fbcc9e4a2ed9ac8688a2f987ac748457be3fa58f660b03ce0b2"
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
