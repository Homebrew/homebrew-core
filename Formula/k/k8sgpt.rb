class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "7287a9fbdfd2245e54f2b3bc72ceee85246f2a48eded003e30bc3af168274c5d"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31fd24d510df5ddad078e53ed1fafb3bcde0b098ccea66cc36a43ce66a0a53d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7010c7bdf198e69d33d0e5cb5139930463e2e704b13229ad23011f4981188468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee73fabe311ff002ced3d127a0cbbbc065d3901565c749242e1c13c7bf36fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "382d3c210f891dc70dc2997ddd797f0acd175c35a71eebfc6bddaa951dcbc966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eed4e241b1b66075cec94ff79933c6063f47173f1dd842962059bf2d87a6dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ce6daa4c45cfc76afe3f1ad99dcaf2df6b30b0d7f27fc8cc56999d65612eee6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
