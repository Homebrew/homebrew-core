class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.34.tar.gz"
  sha256 "ea16939c8aea673e1779647b2dc7d77205192f567e9032bf8c8d3bace40a47d1"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0485daa54857ac0122fa5d3ff188c2867d546562fe6a826a40c1825158e990ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0976c25c7e06d376d38653ff5bb1f0a8c1266364101949481da0914b855f2a9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc5aa5555cf852eceab7961b6454e8cf9a551d16bf422e2658a1c9675eac302"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c1b09e56c22f12af8b3df745c4da4e9e699cc2e784efdbd13ebfbcc0c3bea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b42037746f7849f9612f3f1a1ccbe5fed718ce0c2544fabc14b4387fa40a386"
    sha256 cellar: :any,                 x86_64_linux:  "763b83f5ab167f90c2bde4d1e64e653acfe9b44619fa60a9afd052ab0de435ca"
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
