class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.2.tar.gz"
  sha256 "1c160403ff982e172207eb5975803b00acfaf30dd89b902f0b1eed53d8400f6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f87f329d04dbaa0252e4825921ecf03ca98b815ee63aa69116e912d2b55fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "508ce9f9f823ffcc2eede9553a9dd3661257b2f61a5b033b47bb4eb144c7c0aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e48fa7e5605c902c5e8c7f1f9a5acc337c46c5855916b9a7ccd127b2eadeb682"
    sha256 cellar: :any_skip_relocation, ventura:        "e0de01e6bcad316cd4d09a2a03ac091727e5f9365327b12a6dda20888e14d53e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac36a7f0a2a9fed1792a0c7751437b16b502a8b0a04b53dd11f8bfa8f5fe2fd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f83393a4bb69e2928e28a03e624693b90dad48eb62e522e3a7bb77907ea17ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4e17b6d4ae007d94ffc17600ccab3d311712001d91cb82d8fc2eea3b9c99f9"
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
