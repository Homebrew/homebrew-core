class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "88bdc359149367a2037dfe5dc13ce9881358ae45d03036a27946fff3753d6720"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    manifest_sha256 "bf739b75aaa43556a5ad60d65708a0e191286bc63b94e694c62bf6b9b0a7cea6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99cab94915e491aae342f8bd59bb1158311b4e1b92632f717e04914342d33686"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e68ee2728ce92476f287d82c033000ff0249c26719fe983bf04088606d5eabe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b08963ab7d4d0252a71db266ab43437c7a808d5d775569e2911e4eedb5d6aeda"
    sha256 cellar: :any,                 arm64_linux:       "40a0e80153b20bedbab56c49b9fd26b2406c3448261ad4d1d9d6afcfe71d9a01"
    sha256 cellar: :any,                 x86_64_linux:      "b592a93e1c1cc170d7484b54a763b251dcde860f21f5d3c88aad6d9b6989a3ec"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Socket not found: #{testpath}/invalid.sock", output
  end
end
