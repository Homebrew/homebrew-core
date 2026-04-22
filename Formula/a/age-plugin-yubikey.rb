class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "51e4680ad7ad7f56535e4f3018531bd0196815659378709979617d4f17102700"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47f7f3db0a86732348289dba0a3f3f9c2b3a4dbb5a5ab12914fc9f929875656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3e8b17018c33023f8f0e55eee0564e1352910131b51210f1e3f8c9ef2ea9e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880dd7a46f8aaa2c5bd88f5e7a5559be37fbe673e63964490d8f78ede9151a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "926f27f8656e5e7577b490210d6e770d5ae09d79f4e8f2ff11f9ce7cd6a692a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692b7894d440b28b7d44d18101a27bc9ef6b867be63c9031b022b6d333daf445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b4c8d1155ea7d45f93da94e2b76412a1c470c8b9f6e622600fea1f95a9e78c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "pcsc-lite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match "Let's get your YubiKey set up for age!",
      shell_output("#{bin}/age-plugin-yubikey 2>&1", 1)
  end
end
