class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "5069d3b865495d1aad6b1436c6b6885b55c6177592028c2bc1a79be36f469702"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "168c7f257bc0f0a848e1524e02b5b5fe0c5d391912c892b6e0564caa8a22abe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1254a5c74a80c7063c9e71e8f700e0039838f28006eae2f9cd4efd87d2f4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b139758efee6929162fb560bbd11962458cb5a8811aecff1014df6bd6421449"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a8ae61d4df7fafff64e4107d286f6ecb1425522d81caeb9a0def45ee473938"
    sha256 cellar: :any_skip_relocation, ventura:       "6fe393f70efbe67a9631dfce44be3d17bf5a1615597f65a62e53d20ba8e4191a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d855e59c831ff0165bf8b7f099d5406d1f6dd825c0972242155ed514816f04"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
