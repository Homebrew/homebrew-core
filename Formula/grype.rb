class Grype < Formula
  desc "Vulnerbility scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype.git",
      tag:      "v0.33.1",
      revision: "b0c8dc0e578d4b7c38a6bb4bdfbbda21a4640e53"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -extldflags -static
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/grype alpine:3.15")
    assert_match("No vulnerabilities found", output)

    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
