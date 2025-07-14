class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.21.tar.gz"
  sha256 "b4254c0069fe098ad9d7601157c530535c74961b1a8ca3d2f3ef0fd2ed9d7663"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9920c135e1b99d013e185dae6087d0aa4c9f1036899ab40c742169bfac174e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc25611b4ab170f676958e194ebc96b0312019022fe48bfc196f1094ce9ba00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f59926ad41c2e2441006338c983b01c4ec086b1f63abc398c085cf1969783f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6136e0b56f10e89dd735d0f94620d8e94234de7ba4c51a9c3209d59cdd4c2e31"
    sha256 cellar: :any_skip_relocation, ventura:       "6d00ac0729e78bd253200765cb1ffdbafa9d18273682582f71720bc8ae42fc54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7545f4bfa87e11647e794aa3b374020e690af9246d396e5d55edda842f056d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e463405e6c71e101952b21ebd4c40db7ef8265e91ebb287ed0c5958e2d730aea"
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
