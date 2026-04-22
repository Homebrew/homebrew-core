class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.32.tar.gz"
  sha256 "344c65264fb733a070335ceb186dcdd377a3439502aa73de2609d14cdaf8196b"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a79c921d3ab58ccd1329742f32324b5882dc25f672e014e44195a9126b87a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4bfe9e27f39a9d43a4fc6b05081501475ad3ac456841c10f73ae43ebc4c112d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe73338be434eb1e5727976a6bc4388b2e5e4fd274840ad10d8afd024200feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5c77472edef4611376d2c8760575cebadbdd10cc9c327b211a05498326fd2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04697237a7be9a291b5269cdc48efb02db5c848f0e13cd7f98f81f12e5c67a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1ed1b2823cd27bd0c0761be5294c0b292d9405f1f022c90d35c9a061458da0"
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
