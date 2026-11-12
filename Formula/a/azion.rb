class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.26.0.tar.gz"
  sha256 "b688052d1b822a470409721643979db386f11f69a219b07343e12a78a1eb516a"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edb36164106b64ffba144cbbf6c55b681af1a0b2e81e223654c9ccdb4385277e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edb36164106b64ffba144cbbf6c55b681af1a0b2e81e223654c9ccdb4385277e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edb36164106b64ffba144cbbf6c55b681af1a0b2e81e223654c9ccdb4385277e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d505a5e58457b14a71c08b1683258e9d1e01be8c6795baf9982945911f533b95"
    sha256 cellar: :any,                 x86_64_linux:      "7fea72d987faed9c6b9b683019b22764c640e2424dec351f2562ff3bdac1ab0d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV6URL=https://api.azion.com/v6
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiV6URL=https://api.azion.com/v6
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
