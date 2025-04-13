class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "5ba544b01bb3eaa8fa6e04e8d71bdf5cda19bda40493915e8c53a687a396bac2"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b76ad7e1f3f96ea91d52c54ffd54a124685b194b7896197c8d0698ad36e3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea6f0e3d6075ee74f08311645d36e9a5b17aaef110f586d314cdcaeefa9178d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af4f16dc48fbd4eb27af3bcc91799dc3a5a2392fff0a925ab9b3ecd48659d864"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ffb4fe88769930f4bfe654fe12e1abb2feb4af1e7bbcc86e25fd04ede64b75"
    sha256 cellar: :any_skip_relocation, ventura:       "8b6e081effc03956c6b91b106b80e32a3b6f55d87e6ee3ff245e9e0246ecb05a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e95b20f2a5701a67fbfce1574b9b7bac5a65fb2631eb8875bd8e17e51b40e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cdf988d3c816cfa57b37407c85b947a0e8ea84ce7f6b5c20b50020777929eff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
