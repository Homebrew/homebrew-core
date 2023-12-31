class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "1847170ec1148ef5c7e9485b87ff2419a8c2e04d0636d62204072723a62ea739"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16191b8e9d314678188dfa87b156c37ab44e913a5c0fbee672942bc374997dc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9746cd14caecaf7151423d78cfe358041bc3fca5eb3a7338a5dcbe51759d7f40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "312732befc4ff48dad603fca5d32b9ce31c49a0e970ae3db6995e396a00c7a52"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b506d9e484dc955232f61e0d166d2d2d3972f764628f5d7d634a57dc6ffc310"
    sha256 cellar: :any_skip_relocation, ventura:        "b2842b861b3d6d541fba44be100b8b9555829ffd5b61c979f3f372a0598267c3"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2eb477618e8e67ada695db59819f28d711bc480a554dd90268d0ee40ed90a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c0260d7cca0892a240bfa8adbe519680d481c0cc61db572ea6c55ac99f2116c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
