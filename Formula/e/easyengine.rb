class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.9.3/easyengine.phar"
  sha256 "6bc295a936ecbe52750009d0f23d254543b4e6aa6a701151561ff448177e66f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169b933bb63cb135094d2f406b8b1fa6db242b1241db55697861d39b4bffb9b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "169b933bb63cb135094d2f406b8b1fa6db242b1241db55697861d39b4bffb9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "169b933bb63cb135094d2f406b8b1fa6db242b1241db55697861d39b4bffb9b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "331094d8aadf233c9bfa42a7d28984aa7d9a5ad6a69a92a38355cb44ec7bb590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331094d8aadf233c9bfa42a7d28984aa7d9a5ad6a69a92a38355cb44ec7bb590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331094d8aadf233c9bfa42a7d28984aa7d9a5ad6a69a92a38355cb44ec7bb590"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    return if OS.linux? # requires `sudo`

    system bin/"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match OS.kernel_name, output
  end
end
