class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b9f471e44de92982b7039f486d838aeb7d7f27baaae6b585ecd68fd3197ffca3"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "672b8dc3907e03566345684df10729dd5da79606b1c17fe9c2d7d91ab76b9e15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "549ffdbae9ebe4ea42b0e8c0ea072e93ee1ab00773af07f25ad7604ffa72d16d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "425c8a1a7f36d70c827dd03d04ded972ceeb5bc713cb5ab886c9f7f2a6d9d18f"
    sha256 cellar: :any,                 arm64_linux:       "16e31b14ddea048026442048993f10243cb4b569659b0980750286f5bfd2c761"
    sha256 cellar: :any,                 x86_64_linux:      "67414f6108b5bc57e5f8085a93535f5fcb87ded3556521f64108c675d7d56127"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")

    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
