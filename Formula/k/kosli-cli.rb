class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.12.tar.gz"
  sha256 "887badd7d0e87bd0fe030237e7535d33f654100fbc14164c439331a5b6968f40"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc297ee2a312f4b0f803d0e468bd7728386c102d19c0c5dbc6aab44e3546e453"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a17c02e678f5f2507a28cd234ba0439f166cafcdc065a84880eb90703704f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d9d18732b298f8ad236d5f890d3d35f818406879b9f29794793dbf4c6f4c26"
    sha256 cellar: :any_skip_relocation, sonoma:         "a416511a5e1017044737e2ccc1d4fbfaf306eda60ef92ccb64f067f6ac9a61c5"
    sha256 cellar: :any_skip_relocation, ventura:        "01b37538cddd3d2e0e0f2e98bb35456da2897e15a150fc66a5e82c6803d3163a"
    sha256 cellar: :any_skip_relocation, monterey:       "2365d44fd366a580b7ecae321781e548cb585ba434cf0d00204821b1fb904f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f5b76de5d03b3caaac6523466aaa38d4e83333f23ed9ae582bf1e1c6a0e641"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
