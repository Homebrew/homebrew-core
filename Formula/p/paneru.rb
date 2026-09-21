class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "f72b51ae41d80dd06b06da8474bce44b338c97c11518b5714156ad93abeab5ed"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e963720c7362a1b60389666e837f5270f43d09f7a31b5b5e84c9e61e245030fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39d71dd823da8a782ac0f14b3b96268bae8c0835f19ba42fd14f5e4dddc0bd8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87663c29e5eef02cfd9196dc05ef6792ac9223d0d7bd155bcd6e19abd3e885a0"
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
