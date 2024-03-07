class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https://github.com/jonaslu/ain"
  url "https://github.com/jonaslu/ain/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "08e88e7284956203f5a038f75ac7f78ebc78ff007e2c42592a5b61b6cd32ff96"
  license "MIT"
  head "https://github.com/jonaslu/ain.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa26e7980872d9b3846c33e595579ee4aaa1e7f9057b78956cd6f106823e8307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa26e7980872d9b3846c33e595579ee4aaa1e7f9057b78956cd6f106823e8307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa26e7980872d9b3846c33e595579ee4aaa1e7f9057b78956cd6f106823e8307"
    sha256 cellar: :any_skip_relocation, sonoma:         "132a4e83ce9aeafad972e8434f17637bb86571aa84092645f5623ea341cb47f5"
    sha256 cellar: :any_skip_relocation, ventura:        "132a4e83ce9aeafad972e8434f17637bb86571aa84092645f5623ea341cb47f5"
    sha256 cellar: :any_skip_relocation, monterey:       "132a4e83ce9aeafad972e8434f17637bb86571aa84092645f5623ea341cb47f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadd32385084c1ab1ffc7478131bafcaf8435f089c6225d6674cdac820e8bf16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ain"
  end

  test do
    assert_match "http://localhost:${PORT}", shell_output("#{bin}/ain -b")
    assert_match version.to_s, shell_output("#{bin}/ain -v")
  end
end
