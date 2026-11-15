class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "ffa53f23244f6eb2d3a9d9df38b877dc95c73ad158d52606f965d8c6c0fead6d"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54ffbd77293f75f08b2cc76533def8516cc86e75587ae27ae8b4dd2af28e6c74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e171d0581bacd72af2a9e78d99912236063ce2ba19348223771799024eef3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c56213d0c7ef5559b23d6f6d947b30ef67aa44b98d79c4bdd384cb519ffc848b"
  end

  depends_on "rust" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
