class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.41.tar.gz"
  sha256 "cf05214ac7a7cfeb543011e6e28e1713db2d6475d7f2375cd2ab1d77d39000da"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75c56552ca5e11556cd6d5c5bfffc7936e450080ee70f8bf6824e60933ecf53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7b9b90d73d710b63f27f09204ce5c186226278daab21187bacc6d443daf79b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31652235cfa38dc5e0a336cbc7658195cedbeb19e4d815577db3e4b95f46e23a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ca0ae1dd4166f822948219ec9da6dc236be5f4493eef9e55e9c220eb4d79f8"
    sha256 cellar: :any_skip_relocation, ventura:       "08c4de996a97094aca5a22f9cb8bc81e929474475576cc67451f35cc53396174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f82ecf90eedf0b7c515d3d71b1d4e2d71333c3fa1f4eb89e18a993f90b7f6bf3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
