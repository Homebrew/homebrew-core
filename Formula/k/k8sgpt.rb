class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.35.tar.gz"
  sha256 "101965d0850e29e82e476fe9d27529633320a918b1bcd413d9398ecb1f493351"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97b4198804fb2a2850a06481829e4d0513a021edf27e99526b51bd7d722ce0c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ab85861e9a6f4618d60b8f207eea24a8ea16ff69bdf3771072465587c9c0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd02db31893d96d72e79d87fc0e1cfb3bf090b67e407f342fb26469f9216bac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "684fab573a2983d2b36197f0ff3bd1e6e18aba882d90e73a9977fa1a75ff74c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2480e76625bb9ef6ecc5d7d19c5a2e3b6e600c425069062ad884efae9c06af93"
    sha256 cellar: :any,                 x86_64_linux:  "8ce94bcf747e39ef7897ba44f15fb9d2cee18743dc6415d81e406735a787c976"
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
