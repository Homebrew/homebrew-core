class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.0/easyengine.phar"
  sha256 "d11c9de04ee71b0bd138694e3795a875b4580826a351d2e8605e0857d5b4eaed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed1d137bec2b1235657652906ebc37fff79f7f478d690a024be18e869f80620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed1d137bec2b1235657652906ebc37fff79f7f478d690a024be18e869f80620"
    sha256 cellar: :any_skip_relocation, monterey:       "7b28790b20f6b331b50017703497ebf185a2e19e2c0d25492dd374cc1646187b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b28790b20f6b331b50017703497ebf185a2e19e2c0d25492dd374cc1646187b"
    sha256 cellar: :any_skip_relocation, catalina:       "7b28790b20f6b331b50017703497ebf185a2e19e2c0d25492dd374cc1646187b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ed1d137bec2b1235657652906ebc37fff79f7f478d690a024be18e869f80620"
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
