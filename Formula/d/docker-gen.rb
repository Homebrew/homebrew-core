class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.18.0.tar.gz"
  sha256 "abfe428a64997c1333911845efece7c83facea0fec86091136d985f027368c5f"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    manifest_sha256 "f19c8ac0261a29d0f1ca5b510a304ce013bccf05d626ceadb90f58b1b87ca84c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1243e74a4c9fe25bbc65db3c6b399db299661706e6830ab6076a8d76c7911139"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1243e74a4c9fe25bbc65db3c6b399db299661706e6830ab6076a8d76c7911139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1243e74a4c9fe25bbc65db3c6b399db299661706e6830ab6076a8d76c7911139"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "604b075422f454b9ffe757fc5d6e693e3fff07a792040ff16d68a7c165916920"
    sha256 cellar: :any,                 x86_64_linux:      "b59005ef2f517ea5f822fd44e2c7cecfb3b14e8c48656645b591ce537047b268"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.buildVersion=#{version}"), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
