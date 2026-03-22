class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.110.0.tar.gz"
  sha256 "3b0ddd75f0a7553e4f136a1eae585f542c5f769938c3b8d6a10908ef4b83b2b1"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd337f713fd8fe7a0237559b1919d703bf2c74341c5feaded6484c3e05b070f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abd7057c8227f6388b21013a1bbdc810fad46aa0f554f3d5aef2f4c4dfc9b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162fba7c78b3d0145e4546fd801f337417bb60874d9b2e167182544e73b432c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b732df4f7c1e2367592111ef1a2a0c960438332d3fef0d97ca5cfed0b15ff177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cdfbf362201d476d7772a7887a2cb5c1dbed6ba3add733180c8600fca1c7c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db346e4891b6a6eca79226c4adbdcadf140bc3120ed35e1f89b8cd2beb1d1c04"
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
