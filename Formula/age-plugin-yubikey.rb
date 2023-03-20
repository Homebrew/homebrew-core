class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.3.tar.gz"
  sha256 "79135dfea5f9f36991629b16f60e2bdc0586f506b305059fe829519d02fb6475"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eeb55dc575e59e922664b85a6bed2e729115f81c14f0873ce2f163294270731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b45d329d4f697382a2588875e10d8310175a19d496f0349b28157b326c3497d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5a323e72ab104d8fcf02b77832ed7bfa5305fe7fe90a9396270d5ca7b85326c"
    sha256 cellar: :any_skip_relocation, ventura:        "e9998e0929bc65d8540a9850db00b26b88237c30adde2c8d5ce3b41ce2f5c151"
    sha256 cellar: :any_skip_relocation, monterey:       "8acc1ff40b20f1eb6c85e8594db3e04871310b2bd9ae7bfcc54131b557a5f8f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d88119670a8363897bfbe03fabd0e5eb461bbffef103fd7f018f39257315e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1572595769375cc40d3974dff9036b51d0bcc58ab4abfa648a02c8565835cf"
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
