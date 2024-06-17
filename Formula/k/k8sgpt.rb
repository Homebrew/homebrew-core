class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.35.tar.gz"
  sha256 "1f35e61e60f35a1ddcb3a806f93fa2e0465599a508d080326c59e394186cb1d8"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eac177706481be7df847e182b3bbefa35745bea575f3153d515a6ea9a1fb1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0707680a930c02ed43cc98b2dfb62eb4ee41d4d2a28697aba7ef42d4965cab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087ca2f2ce018b2390871a4709a5cf02a046db1ccc8fffd3703b78d27ecaed12"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a0b10cca6be95b124440d73edeed05c1994fc3c9a6adb365404c829ab5e3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "6502f4fef51a488ee2552d8b48dcc17fc60da31e9e13bd9a7334de134413bae1"
    sha256 cellar: :any_skip_relocation, monterey:       "ce33c6f276b200496ff59577dc76c9d626739d5634e42e9475592bab6913a554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166c9c9461963aee4ab5411b6344e35fceccab445dc3829c5e63a64283cc0558"
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
