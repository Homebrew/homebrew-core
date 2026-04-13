class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.111.0.tar.gz"
  sha256 "01d60c3e785f635da8f060712df2a901025386b740eb173e365ae0c263e66792"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11af1a74755006d0987e22fc5b1a6d9db895a6b70879df6dfc830f051fc4719e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adaa459f32b5f8f06179e25c6c8fcedd21230ba61dac630a5393f0a89673ade1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e98de6486c098c3439606ffdd1ff048d87164e425ecca243f82335b505aa732"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aaa960f63cb72edb9145e42247b56a6d01e743a4066ae0625fdaf2ab0472909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d574e050372c4791506fb58790e46c29a77a94c8ca4a3ab15be27e51d1450ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9af31969dec7a82f8b1be5838d3933e5b5079ed79cc3b292800869d1e36a798"
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
