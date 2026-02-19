class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.17.0.tar.gz"
  sha256 "1322e201e78d755bd090422ce4540470d645d3c9ed14741f8bd6c495759b6952"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483055ad2e32fe63cfd0cb5db1f14fffb0015c681fa4a3b044c3bf24d96aeb45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483055ad2e32fe63cfd0cb5db1f14fffb0015c681fa4a3b044c3bf24d96aeb45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483055ad2e32fe63cfd0cb5db1f14fffb0015c681fa4a3b044c3bf24d96aeb45"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8a23b2f1b6a9db4c9367bb94706a16a5d76ff51f584c9966b9b1130d9496cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e46dc041e0255c2557ae68a301dc3bf472b936391fad90ca74ed631d0f66fc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c3b1a285c3114152aa068ba9c55bef4f41039a46e062b3b97edd443e084f00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
