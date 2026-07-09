class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "5d6bb92c549a1e608e2d54a44dd828651ab29cc0e51f948bf94b14bdc1781c70"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56ac23749827b3b7af90396dfa860b17391eb07b7792eb6e3e5718612a24e964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "152a4afca5ce055a757c8c1d8ec0ca3ec3ca05256a99f50b8ff5f896f5df3c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa080c3305b6c837ec4e2a8829615ab7b21074a64a390dd51c3dbfbf7e0c93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76d64dbe29e46aeb4ed120c2746c876ad6361f34fec680bafb5e263b5bb26eb"
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
