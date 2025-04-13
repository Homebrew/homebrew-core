class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/3.0.0.tar.gz"
  sha256 "670272373f27017dda4425a93d9afefa72f2583ed0f62b9da2a7faa8b77da89d"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398e4971701d81b9c6d8132a18b5101c27083a6fb42a7170f185a4aa112cc2a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "398e4971701d81b9c6d8132a18b5101c27083a6fb42a7170f185a4aa112cc2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "398e4971701d81b9c6d8132a18b5101c27083a6fb42a7170f185a4aa112cc2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "460f04f80f7239c1042a135e482a819aabc2f0fe87cdbd3f748899041a1b95e0"
    sha256 cellar: :any_skip_relocation, ventura:       "460f04f80f7239c1042a135e482a819aabc2f0fe87cdbd3f748899041a1b95e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8e3d34b16f19a749b7e4efb3160f56cad9381daaa49cf41e10ea4ad49745fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
