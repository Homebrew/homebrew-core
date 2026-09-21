class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.119.0.tar.gz"
  sha256 "be9c904938d9702e432e3c24ea2288913678af33968405980d2061d6159248b2"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e62d4cde890a75aa91c4f903f7a9a1a2155764c0b0c96e20836be7d9e4e4c7ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab8ae4d0cc5fc78363b1da634ec793534114dc20689419dd7520e9713b49faf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2f0bf4be0cc311ed1788ecffc433377ba0ef89553760afcf7b1d23078a03efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37410c87cf9a54e1f94d2473c823bce821ba2d7c898f1d923afd9b6d5be1f3ee"
    sha256 cellar: :any,                 x86_64_linux:      "4ac747f51bd4f0f5deab3bd857fefaa8a6b04aaffe245a8e93a4a1d0ebe6eaa7"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
