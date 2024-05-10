class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "c629a510364cca597405f5d19361322e4ed760227f8c72464130808cf94ac707"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5173ae077fa817a8c0eaca25e94062182313ac24a56d02709486fdc43c8839a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4386656401d9c1dabf2208cecafe3be18a04e45cdeeb3ff2d06bdab9c2fa1c48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd62d84b861125fa605f8dcb0f12d2f759faed6741f293be5cbe4a68d9d14b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "666301231ed6246cdd72443ab43741976a0adcce7ffce7668cc2daa1a9f33a91"
    sha256 cellar: :any_skip_relocation, ventura:        "ab478848829394adca0791f6a0598a4c376199b4c4a5156178f8c89ea5ac88c6"
    sha256 cellar: :any_skip_relocation, monterey:       "921fcdd0b42fa345ddda2534a614b1bc9c522f963de679ef9c2bb5c3b95eaea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23d0ff568d00865b0e733466f9bec776f688f854be0f24b08d5d9543ff0f0be"
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
