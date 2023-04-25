class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.4.0.tar.gz"
  sha256 "721c2fd08fe8b7228ea43398475b954a8f0bc259b3a152f6f3b0dc66022df55e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d483db38ef81bf77825584d6139b4044cad17e677e82ab3170511dee1e9253ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04110190fbb7ad74a007b3f8e3529ef1ca7c0ef945dc206b88094494f4448f6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7549e635e0904242a089b71a0d60c212385d2ff5140286d9e5731b7a5c8bd34f"
    sha256 cellar: :any_skip_relocation, ventura:        "bce97e22834bb8bcb69dac6e0b3935b7289ff527f67adc8ff4a44c663c48d330"
    sha256 cellar: :any_skip_relocation, monterey:       "4c172585c6d95ffa9f134db3c8f739a2e52696123334e2b4e093be188162fe06"
    sha256 cellar: :any_skip_relocation, big_sur:        "b306b141a739daa466bd6fc5806897eb4a2f2a4f11ef9b4ba20cf82738ac35ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdaa3e51ea5ade2f1292b027a5ff7b1bf0c793177165ddf247aa0bcf7c27f01a"
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
