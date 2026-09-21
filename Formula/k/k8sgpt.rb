class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.39.tar.gz"
  sha256 "743a9e40521b32663e1f592983d7e4097cabca94e3d0b75ec6e023649d855f22"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d6619d42aa8008ad0b1ba4abbe6cb2538d984bb1447fa0231d8e5fb7bdd8008"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0e65a7a3bc35a6ff8201777045d281cd1db4ad400451a68c4a60a5830f356cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57d8cd69be28b94f29aaced5935dccad496c747575f0980b4e540f0f2e99f556"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38249d9f39342af258781c43ce3aa420a75950bbcd799752e89636d99f2ef219"
    sha256 cellar: :any,                 x86_64_linux:      "e448cd21b680b3bfdf2b72a72719463639d0f388e83d2d11f16d7f3277e3207b"
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
