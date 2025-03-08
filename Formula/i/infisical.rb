class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.11.tar.gz"
  sha256 "fac23179c60191f57f8a79de8047c31f06c723fbff9a3439f09bd7b86abb7275"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86286ae87df86cfabb35acc51a0c790737a7f7c949da2120ca3da8342f1aae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86286ae87df86cfabb35acc51a0c790737a7f7c949da2120ca3da8342f1aae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b86286ae87df86cfabb35acc51a0c790737a7f7c949da2120ca3da8342f1aae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dce21002eae451028eed396758bae61804d4e8e5e0c2fdca13015b7f0d49df9"
    sha256 cellar: :any_skip_relocation, ventura:       "7dce21002eae451028eed396758bae61804d4e8e5e0c2fdca13015b7f0d49df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b1babd596b4c089e292f1aa7d86652df0af4b8cc1042b41ca867c8ac3884bc"
  end

  depends_on "go"

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
