class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.40.tar.gz"
  sha256 "1153994475a609f8b9bb6a281bf3bff517c1fa9390633682eb88f091da8f2ffa"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccefb9f1752eb2e1cd37c4617116855a27161cbe2c8b22b01a6dc472475ad0e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4af08b35567f0a727ad03aee8deba52b8adca1bfff253eed56b78abeffc86ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5a985a9a18da6a2f781c90d2fb633c8026d638fd328e3e15f0b1b20082f603a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a83de3c592541bc95cd3dcb051d609b7afa53f7780831d33f7a43002a06c7718"
    sha256 cellar: :any,                 x86_64_linux:      "9f0a1b9c0b977f07febc6d7b21925de307413361f772c84572540927d1a5157d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
