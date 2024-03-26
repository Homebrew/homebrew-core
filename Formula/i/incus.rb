class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.7.tar.xz"
  sha256 "e6230bee918524403c003f2ed28ba75f1c64175afc11f89147d1ee8dd8a6b76b"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1cd55ac660d9b61a6fd2466e10ab92522c1addf7c55090d0b6d06733ab2d802"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b0c70ea0f3f4e2928cc0a3cf8786239e3dd1521c830b1ac1ac0ff4fa48e1a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee867b3bff64fb5272f392f36fa27e74d7d35671eb9f6d83bf17420938f4e828"
    sha256 cellar: :any_skip_relocation, sonoma:         "918ebd1fcc5a4234d16c5a03f0ff3143e7a70c5fb31d9b8d9a329b654e2ee4ec"
    sha256 cellar: :any_skip_relocation, ventura:        "1903d2692ccd507e6fa2cf190af806ef277a75722a44b0fd312b46785fc3d783"
    sha256 cellar: :any_skip_relocation, monterey:       "be5d3fd65aef67e16feaad3876c276ea98cc957ebc980ff1e1fdf5558a9c126f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4488c373ead4263cebef658a800eb9641695fb1be0365095b66a15922a0ce5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
