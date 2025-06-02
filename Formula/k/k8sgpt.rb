class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "7e2b8649051f10a7b0d5229e7f81cf8d436d4feb6100d152202521f3b271c7c5"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c735ac98d8205eea964e0cfd3c43d952495c50aa6ac417092aaa6d9af5942abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2193174a3b3b1e922f2349fc38fa00fa97a08631a55e5bdcb24015ec319d4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6876ab18c6d5f548f6df9227d848e94ebb7ceb57d1a1d4f882067730af0b72ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d08733d4899cd6c3a5d82ecd05488ff04176e5b82abddc0339edbb1eedaef61"
    sha256 cellar: :any_skip_relocation, ventura:       "07e9dd30802b27a9ae2ac8a81889a2ccf3759ac16c02d947499779252562a20d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ee62d99af2ed6fffc3449f8533b78a02bf194473533f3b086b5ef512580519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb3871f189c8f9f400ca743015878abb6b10272339b1efb482932de0398464e1"
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
