class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f0dab14876c3e6d37fd99a7e5ba2d9982a00bc165973d1a02f1209f633a2286a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5abc62f6b6045f7818df9480f7d61a1e284dbe76c6aa42699ab20a3d71f77c80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a277e14be273b0dca5ad0966a68a1afc727bdcaf1c97be0d0d09a7b61bcb715f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d1898491e0cda909f0d3162b970ebf2ef4a3965cf7cb359fc016affbeb914a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "916677612ab26e46d25ed669e5aec19a27868a6f1049b1c3c2a1b1fd7661dd65"
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
