class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.10.13.tar.gz"
  sha256 "a9853bbab2ffdd522f59dfb1a5ffd0f3f83083768dbed8db558e0f45198bea8f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82f51a5b6ab1da70f2ffdf83888516453a3ff3dfe8386cda6503d1745793a21b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51a8ccc98d73a2dfa16e7029b8eac0be8678667dfcfe6caee6439e5295536cdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "905f314fc23cb50cddd86d8827062dda63110c696c6845db42507a83fa8acd81"
    sha256 cellar: :any_skip_relocation, sonoma:         "c363907639e68d0273803f1254d73b8b01bb5fd5a74b787376ad2bcacdad1754"
    sha256 cellar: :any_skip_relocation, ventura:        "563dc3da502fdcb012b9d04449fd65fb21c6b06937ec2bd3b6c0857c9a69a12d"
    sha256 cellar: :any_skip_relocation, monterey:       "656613b117f59d426066bb401b7f5e295ef142cfdf902278c83aff40c98414dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46ced0343a1e092b0cd206af8558f33e57eb10f54fdd9eca14db84c76f3a495"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
