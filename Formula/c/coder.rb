class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "e6a4a1c3212246f745aaad6788d88c0d3a906dd383182f0538fa76238eb6e636"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9b0250557b09c95627da1e4b0333eb44b78ca0322e07c2a17748d329fc0ce0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3940f89cc65aabde1ac7854ea85090a6b93507c38469206cd600745141eb9f10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3e4be4ab22422bbff70a9e73bc280a5b98e21b68aea23d6bb27f59d97e7f48"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf84415963c38d1fa3656d75c4f58d273ee74c4e6ce8c1c4cac4a25a1ac79d56"
    sha256 cellar: :any_skip_relocation, ventura:        "2bedae4c2ab15107cdb017a67387651c47ea295ca3669cf9db2932591cb72086"
    sha256 cellar: :any_skip_relocation, monterey:       "0f567eed291c2aa6a50043a8bc39993e8a6a42a4328d56ed223cbb8ae2612a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81db31959b0778ba74baf10401fa93b9a2db51f71fb04feff64b002253b064f7"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
