class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.71.2.tar.gz"
  sha256 "37d6395b087df7a61cd6fde4942489fbef26c7fc74604971a0a7eec3c48af392"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8abb2c6cb951b406c8fc29423b33121d5c4b9cc153efad57dabc2ee124e3d75e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd69d6a3406a90b9b523447dcd15cf29694e0a1a02223bfd1fd6d4ec07aea4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cab44d9656d8c76d3417fc6ff0af5f7daac9215873009ea83f43a2eec0f4ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f2d518eaf7ba4e159485350e167ec30373a84242fe61138c4f1d085df3a016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94501ea8540b777b7c7311a1e3aaaae79343b703e1e0ea692d0deff1d61977b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be77cad81c909277fdf0a88398895df30ecf3f099f9fe1fe08fc74f05c4e24b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
