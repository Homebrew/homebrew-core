class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v1.0.4.tar.gz"
  sha256 "5e1ded9ad44166cb9cd699d6e379dab67c583a2e9fea43b6bdfa99a13495c147"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c57be55091213c970bfb0ed344673a086a048598adf66fb9bd8bb53f1f61804"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfcfabac480af6369348ffe2393c6076c0f8cd86b30cdd6c70aa73359a3c0fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b879e92fc04d3ddf08214dd06ae7ce48a86289c17bf02cd7893bbdd492c5a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69c92eae71dbb6d3a997facb7ef49e21054f8a976b515293a54c69243b29d93"
    sha256 cellar: :any_skip_relocation, sonoma:         "b37e95fd90b1f47663f90326e38965e99e9e22434ba5fc227b0225c84a6d29ca"
    sha256 cellar: :any_skip_relocation, ventura:        "ba9f0caa4ca86f81a45a7b05b4d33ae563891eb64b3884a8fac8ec9464effee1"
    sha256 cellar: :any_skip_relocation, monterey:       "06009c340989498e1f5aa4c37f5b3fc5e434dc89151eb6eb8daf9e0fce831030"
    sha256 cellar: :any_skip_relocation, big_sur:        "85b1fbaa3d600741a8a5a76e12df22b2ae7ef5ee598b98343eba6455c8c40ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360039f9b6a457d37e23fff0dcf4d6cfb8d3f9f9a68adaecfd02251c21fe4f03"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
