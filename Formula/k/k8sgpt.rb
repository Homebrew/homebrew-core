class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.41.tar.gz"
  sha256 "5bf358be47b5e7a9f78bf70318244acb737f5916084c85212f898aa6d12e323c"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a25091a0a7c9a600535278fc1f60a53e79a343fdb6ffc02e7f3e925ad604623e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e143adddb0cfc61b737bbc56ef0b45066e9e30c55b4c52a8ae088c347b41145c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8721a7155df58096c40ac8fba544130bb464fa8bca1caf998103cb2bfdffe32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f7c3e8da3ef5d2738cfec0e3209ff0a274713369d29a0ddb117582ef1600d3c"
    sha256 cellar: :any,                 x86_64_linux:      "a1547609059266dc134533cc786d38dd88f95ab95e4ce3253089eaddc3bedf4f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
