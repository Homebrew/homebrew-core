class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "545c05d2b98c1658dd65b4af9d13e2de06ffb400654f18095d4fa49a79e93ca0"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afabd5e4c82b36b832882ef6b459217a6a983a32daac943fdb1e76420db962d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73994ecae3c8b9fd40cdd805cbbbabef84a6b9083cc8e941c127d502efed4ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d99ff866220019cdbe58dc073500965080213173972067ffdcc6b2955ccbae"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8d94a8707b08914823cff7c532f89a8c383c3131e1c86d788e16aa831e7462"
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
