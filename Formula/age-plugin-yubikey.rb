class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.0.tar.gz"
  sha256 "3dfd7923dcbd7b02d0bce1135ff4ba55a7860d8986d1b3b2d113d9553f439ba9"
  license "MIT"
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a0561a3dce577840b28c257b669d36d642eb4c88f0da84a2f5618bff6aca59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cd5ef000e9f3542628a393c64508457224e728fbe6e0299fa0ce5e30bc87103"
    sha256 cellar: :any_skip_relocation, monterey:       "0cfb5d2c8207d5154aee8229ea6bb8492b50189a7185d8a157fbe7ade9760589"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea1e1c9b62ef9facf8f3aef7f78be4d4f31d5dfba1b34b8ec19e86619ccc9212"
    sha256 cellar: :any_skip_relocation, catalina:       "4a2c473eceb783b4a8e3d9d386a467c905b1f818f4872f5a30067d2e56189215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67361a81761fa0c03aef292d8b0b5c2e91c4798f1b9aa6e898abbf9e71647f06"
  end

  depends_on "rust" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match "Let's get your YubiKey set up for age!",
      shell_output("#{bin}/age-plugin-yubikey 2>&1", 1)
  end
end
