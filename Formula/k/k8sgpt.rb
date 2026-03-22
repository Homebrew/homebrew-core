class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.30.tar.gz"
  sha256 "20f888735945606f2dbc6d2dbe39b5c29191ae5c935950a753cc6f9202032b48"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6d9b30c7338fc3e10596b6d84f12837c4e228eee46147a036bb4a3e0c591a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17581a2a7a1035d9c12dce18f3028e90e7e6f37af0ee7487a8650a581a710b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128b51451e2702e275ac62833899d539ff48606a0a2752baaa92563db4d3c064"
    sha256 cellar: :any_skip_relocation, sonoma:        "4824973dacbdc4788e753a957f969e3e1c0c98d9429d06e87879390e069c3924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e0a279d15a5e1011e1f1a51a12a23461d259d14cb53a0ce6b503ffaaa36e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8caadb9128e7dc6d45e12642e0e7ee4782e618c765672b6a521392952ae98379"
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
