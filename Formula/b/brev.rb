class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.262.tar.gz"
  sha256 "07058da65e5101ff2a67fce08e543ec3930e46adef7c5fb0427393b53e499904"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30f4b0b55524edee72485d51529b5cc5bd9a72e4fbf42cdacd4f9b8798296290"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a5c8e2d8ea04651362221f5a31cd203f880f81ef321d74151bce7bde04d55e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d28212c52f6a0639f5dbb1230eed159a05db696c8ca2225a95ed6f2d81bbf3a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae879d1b105d39dc1f60ba894845132eb71c6d9b18e21bd43a916d1a3b6dfdd2"
    sha256 cellar: :any_skip_relocation, ventura:        "3ef12aa829a25ff80e26752a60817b99a27aa3a8e2d2be9d53ee54a2041bd21b"
    sha256 cellar: :any_skip_relocation, monterey:       "a3bf373f1cc0eb210d3159986fdd4c6d9de5925910c2b5a51d5ee7bd08cce435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2075ed369e28f573e7357a6e99c7983742e39fdfa84b64efef11f60c481a5eab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
