class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d576b1be8294451a53dee27e9c95b814d2641573bd4a1963de468498347802cf"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31768f5c40e809d0517bb53112899083f9b8a012919a7ac1a35cecd32b782f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79bd1d9bcc6929198da2e8b45a8696d1c4d23aacd715c76e542bf6a96f53c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f7ea52d9a5df48ffa50dddff4278235bde7b20a86b50bbdb86766530f93b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "3269e471333b67934d9679ed06ad78ffed1440e5cd2d76f8d8e6f0114255b10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f89b1a3d4455cfe5d49fabb951a3a3e4815d5048c28ec64d4878759f964c32e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a3fa46ee479beb11948ff8f5d04ccc70f5b96fe0f09fe594bfd67cef781eb2"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  # patch to add Go 1.26 testDeps ModulePath, upstream pr ref, https://github.com/kudobuilder/kuttl/pull/664
  patch do
    url "https://github.com/kudobuilder/kuttl/commit/80911cc18d690efe88a8b12a32b419b495d7bb20.patch?full_index=1"
    sha256 "8749ea6b9cabaa92b44894b8ed5e6a5271a9bbb5fa76f35502df948d529b83cb"
  end

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.gitVersion=v#{version}
      -X #{project}/internal/version.gitCommit=#{tap.user}
      -X #{project}/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = Formula["kubernetes-cli"].opt_bin / "kubectl"
    assert_equal version_output, shell_output("#{kubectl} kuttl version")

    (testpath / "kuttl-test.yaml").write <<~YAML
      apiVersion: kuttl.dev/v1beta1
      kind: TestSuite
      testDirs:
      - #{testpath}
      parallel: 1
    YAML

    output = shell_output("#{kubectl} kuttl test --config #{testpath}/kuttl-test.yaml", 1)
    assert_match "running tests using configured kubeconfig", output
    assert_match "fatal error getting client: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", output
  end
end
