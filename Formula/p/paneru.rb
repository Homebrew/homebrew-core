class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "e087a421a41f50959446f856fa2e70fb3b57942a78c425d83f78d9759a295694"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25c286ab0642c3951d5ce311783d8824d16b0d766e315655187aadef6fe4f952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e771ddd9414fd7c6cc219b806deeeaaee7f1f8bebf1e567418277d287c1ad1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eff02b5d96faa72dd40bc1881e2dd78bfbc64d27ae69ae83af0053b5d53ec41"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa97e1356b4b5f3b606d0faf80f29e04837677981f3e9b4007df4ea4fa623aee"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  # The test verifies that the binary has been correctly installed.
  # Once the binary is installed, the user will have to:
  # - Configure the initial configuration file.
  # - Start the binary directly or install it as a service.
  # - Grant the required AXUI priviledge in System Preferences.
  test do
    assert_match version.to_s, shell_output("#{bin}/paneru --version")
  end
end
