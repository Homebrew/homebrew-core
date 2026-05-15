class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.112.0.tar.gz"
  sha256 "0e158ac297c79a132c3d5960fe13995ecb38a7f9fc81402d8102c220600d3de8"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "513e05ea46524b3973b801d7ff3b0a364e9212d62565b3fb44f0fa4ec66b9f87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc0b4bce7279b02217420e6da6fc525f9256c8dd64de57b19d740c18025c6b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0801736cec0f4fe04c213ce9e7a0b588bc48014edaebc6b245c200e8046bdc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a7f4dee63d1ca0833534d26f5606ba51707989ca3b843c376fb6e8e8f21846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c111c10c8a8d21699fba83b03fd34e7ec2c103985a15b2b284224f0074eb7fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32afcb923562e4b728db60bcf89724f2060b9b93663e57d55764f85cb0324b8b"
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
