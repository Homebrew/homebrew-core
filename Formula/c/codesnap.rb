class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://codesnap-docs.netlify.app/"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "21599899581c0a8dcdd3a8fcb30e212a521aa99bac35b9ad04ace2ae8059e256"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b20f87a33e824b93d3dd868c1ece15310970aa4754e6ff637a9c494cded69528"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27c8a0ddb9593df4eaff34c151cf1991e4d95d0c3bc284b34a67163397554b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccd056eeda264fca17d44c0b8a1985c8c3574a6108811b42a58a48f12fbd5246"
    sha256 cellar: :any,                 arm64_linux:       "2ccd4c71eed7eeab7bedff6913fbeefb05854d0d5a27d155a2d37d2f8f0dd398"
    sha256 cellar: :any,                 x86_64_linux:      "9e4d02cc56df7fc995c1507e65035201eb618b2ec858d4ce3e695c13032d4e55"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")
    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
