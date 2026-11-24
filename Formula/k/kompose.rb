class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "10520140fb3854fc19471c32d994e4479850e2fa2e44f88e07d6877872c00baf"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kompose.git", branch: "main"

  bottle do
    manifest_sha256 "c5fbe51cf9f2bee1b377a8ac532ad49897af2a355c338ccd6a8354df1d5cb41d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3440da295f3722b8be8aa64972f7c25b1904d791878e0ba87f919ca6d890a984"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3440da295f3722b8be8aa64972f7c25b1904d791878e0ba87f919ca6d890a984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3440da295f3722b8be8aa64972f7c25b1904d791878e0ba87f919ca6d890a984"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a26ac3c755b0aa933439c142190bd0fd39d6d9f67cdae7b2f422ca458dc9bc28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3092408cc63035d0c2f5f1a8f8573f97a91d9335f88c2890881dbfac32da4aa9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
