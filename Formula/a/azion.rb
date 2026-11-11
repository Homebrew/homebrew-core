class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.24.0.tar.gz"
  sha256 "b0b1c0c34b2285585e0e44abc2ac5e718623c3cd3fd41a4ddf25bf7e20bc8b57"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f13112d18aee0834a401f940e2997b3ac1e027201a1568120929b3f04875d978"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f13112d18aee0834a401f940e2997b3ac1e027201a1568120929b3f04875d978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f13112d18aee0834a401f940e2997b3ac1e027201a1568120929b3f04875d978"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a2b4418b7090cf032552c03a1c5c100adab659cc5c459c02d2189e5e64a1850"
    sha256 cellar: :any,                 x86_64_linux:      "ea2725f9b42fe6f8cd4b4913909e00cca9771272efd331e8eb64df8b0e4da677"
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
