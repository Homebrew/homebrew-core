class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.116.0.tar.gz"
  sha256 "5e8aa8cf1ae21e46f1f5aa8349af1416153a9a3299cd80f5bb1ef38fd9d38252"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751fb36c8a2f5e38f4a71e91953ff73b730d777bb7fcc19d04ed631113b0898f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990db424f62f2ea43f2593f13db01a0c54f010286a690ea2594606567d4dc1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb30d291011555c89345547ebc7ec50a1b735ecf0ff7ed894fcc84c4b8f7981"
    sha256 cellar: :any_skip_relocation, sonoma:        "01adcbe83e71f9712ea2d4526f31c0c43bcad49b5972eb000b830d68b20fd291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223551336c7ee1e0ad99818096a9bc3baba7f8c1d7e23b9ff1f1692bd0a3b3fb"
    sha256 cellar: :any,                 x86_64_linux:  "0e2f64ea930d4ca552fc52cf9e2a1b3dd6d8782c7615008b0f59a322f7c3825d"
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
