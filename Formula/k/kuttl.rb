class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "03832766b9cbc6df5ee89668f34773074c91b67806ada70c18f13b2cacbf6ce1"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cda7934094575e8a9788d66e5ecc75a22f840132020b1752e2b96c517c3cb02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f2b46e610f641f50cf50cfc01c56b960b7fc5e28acf8b1e837149628db1e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6076a9df8d80b2dd8a6367bf86f6a2e4dc592c68ff94bc484596d57718247ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad73996974ea968b07c6cbe3548e8d0bc9822d401329fa2124b212163d6e80d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "add1eafb789240a5f286712a64053edb434003ac3981690691c13f373edf7e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56b90a6d0bcc3ada605317e74a64851e87435018d3c3a8205fa56d1f00bfad2"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

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
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
