class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.28.tar.gz"
  sha256 "9edbe1e62427e412f4586337349b4f16828b231a6ae6733c5f6c0305aec5ac8b"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0005ef06d0f3b377dd52b81750a590b37805b8f3f2a6a9eb8f373a0b858b051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1d84cdc9e62d1c89ecf94f19ab0a34a0fa8137299101b80208563a9d041890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2b0d4367039944b6a8c9856303941533d328ef2514b9a04e2b25d1f9d72459"
    sha256 cellar: :any_skip_relocation, sonoma:        "a682049ca7bae144e5556ab099e2abb9216d0a4e1762dcf47bff24337256cedc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c6199caa4a773a393211f9eb5856c2d6c545fd68087cd2216d43ddc9e90022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4081106bf7a103ee13bd6b2a3a7d45b89f5e765e5c18aa0c658111263e5182bd"
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
