class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.40.tar.gz"
  sha256 "ae61537ae5b3ab733fe3d29218a3abe5376337e1765f0456c82e88abb9c6bcfe"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22d500e85a13ae94bce5be3471eb9c2fc10b343fc335adb9fd6c39a9adfc9bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e083003c0adeb8965f89f3e644897ed41a15e910f047f058397b78f69be60d87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f618848a80994da64008040266fb3eb25ce14712fadd9fb426c5bed35ec526cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "303dad67da4573f441fdba2cb8a7d66f3931f4cd42667df382b0e420f7bb7d91"
    sha256 cellar: :any_skip_relocation, ventura:        "281bc1a1360548056f75b9656ecfc9b4f40ebe0887fb288ee9521df5b7ba486b"
    sha256 cellar: :any_skip_relocation, monterey:       "4634ad496c6ad9a43d3b51adc03eb625cbcd1cc2270ca766640cc04a69d12a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba3ade14ec3c391b2e616fc3ed92a39e31403114efe443b6a5bd65a1d2d5443"
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
