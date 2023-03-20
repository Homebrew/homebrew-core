class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.10.2.tar.gz"
  sha256 "8d494a03b17b5d8e8738f59ce4041da97c50f503ef039fd02e7a8f40af3006d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a2248ffd303905eb10912f4d0f41e93504612a4a31f395192e7ae5db241cc92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ece45ba4bbda860e00756811b545c41a20649c3f5091e81ea385f7ede560063"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b319910dc71706532db3d18244f9c72b32db6cdfedcb5bce1560bc7c0f09525"
    sha256 cellar: :any_skip_relocation, ventura:        "d0c1fa63c697555038c9fada4dba1bcfe412eedbcbb4e3532571446e638737a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ef91e0183b873edcaefe355ffc6d712f09a6f15941acd570eda577045651f144"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec49b4cca9d74462a326fda8280ede7d650008e0908b6622e8ba610747e6031e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69526424f8a05cea21a5e49f0475cbe7f2c3f826e500f2966c72bf672d47e52d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
