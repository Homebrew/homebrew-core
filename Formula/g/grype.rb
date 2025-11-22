class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.104.0.tar.gz"
  sha256 "0bd68371aecca6bbeae40cde10c1d923f64144697569c378576dd48bc3dd002c"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a4de643f2ee36b4ec2e02424a8337b07403e110bc7256f0b22707e90f6e307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0974a41e8ec8b714fe51ec47a6d03f8489beca77ea897400619482815414684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c914aeecda38645ac64f3f05eaf3ca35e39e0920adbefda7dc9ed856de6e155"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4815eb920e37a901a683b4a406002aad98fde84d811b8a4557a59c3f935731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c36f0dcb2b0a4f1f58e95c86ec9fc5cb1ba97bf8d4bce2da67f3697dc9b4c3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd88cce04f60b790c1cc4c8531acdfc8c357b629a03a2f6c9acbbfa156da96ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
