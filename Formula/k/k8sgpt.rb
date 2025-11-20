class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "680c23f9f86653508968a716214d4845d3d498ef252255fda270656679491809"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c3b8d9b2237831db8685ceb2d8ea40ab7bc72f967b3c472b3fc976c480f0b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e1285b626df033b5875ce7884ac90016662cda60841d6e37180acac524183f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4c32e6aab9b2bee028b14ea1e980c1171508e92890c4656b4fc5ddf70a8bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "359857cde674b404fa74cb196bbfe358972a5fba75a902736b53ffe3581fd6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb5ba08e7054cd7b5748c305384a1e569840d46b1bed4a83524844f9acfe196e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26655f72eace559b32065237fb28fc8436c96fed3bc48c1caa27c90ef4fd30c3"
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
