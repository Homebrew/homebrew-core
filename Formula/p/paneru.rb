class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://github.com/karinushka/paneru/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "67c5f979426569be19f11475dfbebc4def13fda94c1862d8adfd65d77f78c6ce"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec097880650768675be9d89a161cf4258cefd690a8dfa031d8f48374a915d98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "455a2361f1c79f8947c11778444b28dbe1430a9d5531b2b534d9722b98c38161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8e7cd29ef14b352960205cf5cc5ed3112368efb42ee2abdfee702597f31a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c566ad8d89425e01eacfeaa572be5eabb1224d00f417017b27f240e54a3e8612"
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
