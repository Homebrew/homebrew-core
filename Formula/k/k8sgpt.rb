class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "a4bac484569d1482e26ef9aa43b9bab1ef66621f6ae938f9e435de7148bccace"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b13054d1c8368dc0e6998b8e50cefe9a3e1ff83bc04ab47a8defa1a8242700d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b575c0f02633c55c276723268090b5df5b558db02f97da539dcca07e925c294"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4497b5e9054de26dab52d6d5e23a863fe2700df9a4a06024ef27869719e603e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f71eeaa60211e5c10f147d7bfbf0b1361feac8ea8337c63f8e21041e8f6ec72"
    sha256 cellar: :any_skip_relocation, ventura:       "0df51313ed68e9aae49ef8b8a3c83466324a4c31d545a7d1ce2843ee89efbbc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b8e78c6039938bc5ab8f5d6ab0e56f3934d5058a85346f3fd2a76062c82e0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab74a99cdeb8f39e2dcf0cfb56f420a175cde5c414a825e316c5e291f381b2f"
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
