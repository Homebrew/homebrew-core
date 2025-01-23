class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.48.tar.gz"
  sha256 "136aea5b15d3d3089ae3e2306cd5aa306e29f4fa95db99074ea561d74808b034"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f602eecaa26e3cecfa32b30336cad0b9dd9d4aefd2a18bb0735d7fb014fc7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d69d2ffb1e6370c415903a97d53822b3815e020d41f41554d7a7e51521e0080"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49a0ec70ce339484618361cc51271846ba04d760c66ef5d05c39534079debd43"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dee8f6e3826a7c9565f49c1cd76aa82b6a49f32c4ad9db32314fffcd3848f47"
    sha256 cellar: :any_skip_relocation, ventura:       "b6ece54069362879080ed0d0f5c60987aafad244ec0e046da72c9fd77a764e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d761977e246403973e65fc137d9392e7ac7943794c2b3be2a70490874a261fc"
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
