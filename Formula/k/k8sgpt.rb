class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.25.tar.gz"
  sha256 "ceb21d82c0de30f56e326e675fff2803cea0b3ff7402aa6602516b3e76a3f803"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a99dfa76ee3fa87f91b79004886fe51466b7788f6a95fd78038e01d103889804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe65b50b8791bfa1c92eb111a636c647ce5d12e407561233ee8a6909b7405f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698036414825e092c65eefa32d6ba5fff5f61de84b780a8319d0fc1af93047a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7daa2a5c350f9776297afc2ebc2143ccead30dc5f21c077ec079b3fc5d22aab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf74babc3e6c8e5206d332ef800600a3f52689f763a0c201798276bba6ed4561"
    sha256 cellar: :any_skip_relocation, ventura:       "1398fc320a157ac14b2430f1c4728d14424f53580c97531ad7e274a5f8afc908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de8f16f7a07ce958190eb68fad47419977c97d9ad3acbe31cc3ec79a6201e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c240e6a2f14deccecd5b69a16016bb4336323c8077479513a64f050b4d6cd7"
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
