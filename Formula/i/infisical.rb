class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.4.tar.gz"
  sha256 "c1feb571d7bc552be7773c69eb5ca50ef836e83b3315bc7b5305b43bce58aa5e"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b05ceb87bfd5a3d0cf6bdbc381a2c78f3d5f382ff5be6974825093d0df6f542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b05ceb87bfd5a3d0cf6bdbc381a2c78f3d5f382ff5be6974825093d0df6f542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b05ceb87bfd5a3d0cf6bdbc381a2c78f3d5f382ff5be6974825093d0df6f542"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb232e0c304647c237abac6e202ccad1d0109915a837a3a20586dedfefbdbea"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb232e0c304647c237abac6e202ccad1d0109915a837a3a20586dedfefbdbea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f65d44bf5b2c1edb6d209b83ecee996675188e03dd0844fe2beb7c82fbfce7"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
