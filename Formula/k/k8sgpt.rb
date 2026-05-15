class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "c09399453045a092b11da651788316103b55244ccc18db51900c1142dab26f24"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21cd27b6ffd6d689b0e585fa1f88947014aead3eaca9c8bf93f965b46a7aa4e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e6cc95360d22f4ccea8780fda3ed26e4cec911e5e4b9bfb602a341aa036dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73e0938dc85284c0db7dc066c6aa88f324d56ba2c6d0a52a8da4563e7d6a25e"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb96a1ed25fa4858466f0caeec317ca3be80131f1f77689a93286211006a182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68370a09d1492e8fe89affb075e82026a51d9c7fdc2a1643f7018b18f191a779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1cefb298bbaa09d97fabdaffd12ae7b47789727bcebcf149ce189f7f35b2bd"
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
