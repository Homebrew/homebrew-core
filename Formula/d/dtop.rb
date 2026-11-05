class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "6dd06a35502cbb91db9a89d991d4db1e2cc536c5c21b8e54e08f86e8b4dcf638"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbf20888573102de41dc77f6bf2299a0af817242c4d327c6d2c368fb79a17c28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c9c0a363e15651dcc682505aa217362f2582b647130149de06cd155be906ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45b0b3860969682356fcc122c55ca07501fab815fac4e7009725db93d2d87f8f"
    sha256 cellar: :any,                 arm64_linux:       "e909ca1832c218427ef00dda225dacd9b87fcaceb652288709a092fe0ab2751d"
    sha256 cellar: :any,                 x86_64_linux:      "e8995577c55d53f717828492b1df9223a59374c360762ef424ea7bbc8c72f2cd"
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
    assert_match "Failed to connect to Docker host", output
  end
end
