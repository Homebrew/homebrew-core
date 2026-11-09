class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "ffa53f23244f6eb2d3a9d9df38b877dc95c73ad158d52606f965d8c6c0fead6d"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b47300970bf71e80ad07618058aa6d7b0f9d7ef0dd0832b50910f910f692db0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5fc00ddae3192450ec1d76de3b7e9643cdf3e2b0449e8dc63a3892611e3665d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcc502904732e69e2fea7bd872392862f4c4bcd9b5a0d3946380fab6a395f988"
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
