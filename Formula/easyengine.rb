class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.4.3/easyengine.phar"
  sha256 "f4297cc2377dfb25bf9384de5870a9944d48d78147186cec8a1f74560c77ee8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea19bbb0d1d798dfd1818d685d275e772beb25a6a4f648a7e305ae77b7b80e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ea19bbb0d1d798dfd1818d685d275e772beb25a6a4f648a7e305ae77b7b80e3"
    sha256 cellar: :any_skip_relocation, monterey:       "82f9b02718b03c5f6e1e71bad551611130906e7b2ebfeafa244d2a00aea45ddb"
    sha256 cellar: :any_skip_relocation, big_sur:        "82f9b02718b03c5f6e1e71bad551611130906e7b2ebfeafa244d2a00aea45ddb"
    sha256 cellar: :any_skip_relocation, catalina:       "82f9b02718b03c5f6e1e71bad551611130906e7b2ebfeafa244d2a00aea45ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea19bbb0d1d798dfd1818d685d275e772beb25a6a4f648a7e305ae77b7b80e3"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
