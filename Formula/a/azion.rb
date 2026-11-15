class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.26.2.tar.gz"
  sha256 "ed3da22048d5add0433863ba5de6340e5ecf2bc5bffc6d9c70736ffccc1d0447"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33dd9eb5f46b53b3e086c401e85cc7f60d8f2b70e8b7d2a07960191c054e7731"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33dd9eb5f46b53b3e086c401e85cc7f60d8f2b70e8b7d2a07960191c054e7731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33dd9eb5f46b53b3e086c401e85cc7f60d8f2b70e8b7d2a07960191c054e7731"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5edf0c7b6a53f5d1b9db44f4404da0a76bb7820029fa363685d3d48c72ca1d3"
    sha256 cellar: :any,                 x86_64_linux:      "f533eddff0d1399b514368a269d7a13b9d24da6c102cc2ffc7d6826475bc1c1d"
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
