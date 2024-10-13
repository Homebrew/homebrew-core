class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ef47c24a52f0aabe7c7012166b9d7b132920f081573d142e0fb2926326ed4079"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6010669c7ec84f5932d93fa167adef32dd84d38a0d4b941f425b198b809fe7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca86b727630282d84095ff41272e525e266cc3a2b11106ea4db24ca49a2cd901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "522c47471a07eeb596220d40bf2b50b60b9661fecddf5208032fe5d72e51319c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ac7755ba43edbc5b3703f7995a239c50ebccaafd3a2428a1258455e4a47abc"
    sha256 cellar: :any_skip_relocation, sonoma:         "039b14d7c697d903e60f03cfd3e58b0fa42bdfe1475328b90894ee72bf545866"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfb8ac997969b4a101e97a0a72e7932a0ebc87ef7a75b8c36d90546b4486df8"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c5f11760d97d994e21fcb265fed7455adb6d90aa24fca441031141ea540a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2729e0a0231afa10e0413ead3ecd05b16767a902aeed4a2549559d15c7e30a3"
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
