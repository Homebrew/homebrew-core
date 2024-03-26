class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.7.tar.xz"
  sha256 "e6230bee918524403c003f2ed28ba75f1c64175afc11f89147d1ee8dd8a6b76b"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d00f1cb16c61c4f3c8cd1d54a194508a7501198fb7c701cb4b9bf4e074b21333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3375f779341ed562154dd8cf06d2f7195e1f4a2dc39e3f10e1b4c2338a4fd69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14ddb00a041354bbb0e290285f7d130f09d0eb57e279d1e7493826d343b3a9ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "871288a638822dbb10587452cdd5847bf65f4fb4c0a1f95e0f49f0553af5496d"
    sha256 cellar: :any_skip_relocation, ventura:        "e9166dae7c32c45730f149393e88fd63eaaa36091bc48c8e08196c9492b6c671"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd537cfad6d092179a58f96819fd8809894e24275b0810b1078f62d141a25eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d173e87930c3f0cadd31bed11be7e93c18196fa1e9dc073cf9e46cd307c9df"
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
