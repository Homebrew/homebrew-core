class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.2.tar.gz"
  sha256 "1c160403ff982e172207eb5975803b00acfaf30dd89b902f0b1eed53d8400f6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddd73e1a67973bd9ab1e7abb535a1c905a32f4ef0cb3f783b3d27ec60888f89c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3f0ea31c694a2854dfe102b85d09dec920bc22bcb5db49b55c8e94e9c15c67d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcbed4def954e7860791ae98ad64fb38d9403cde71594ad1f17eac84156e1811"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3b8a3549c8f9b2843850ced673283ca367c8bf95f031bfcdcf0c004197eb75"
    sha256 cellar: :any_skip_relocation, monterey:       "d269f4d3c7178b244ca4eeb9caba2317d1197a8235be3fdedb504f7e37e994f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "74be2352f7838031a6e92dc4aa7f3c100c009de05aad6c9a44716fd035f14b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3266d7111f2085cad6016373f0235bd353bd4a1aebd6fe84955e01edd16c3472"
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
