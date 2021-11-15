class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.4.1/easyengine.phar"
  sha256 "1554946f9e14165a9f25babde85941ee8a9f834a1d2b8364126fe36be596dbc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b06295008315e99212e35a1c8534897362c3a96311f92980d88dec2aaf8e4fd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b06295008315e99212e35a1c8534897362c3a96311f92980d88dec2aaf8e4fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "12db971a1eb1d567c1438c476c69a01ace6c3cf08cc0eefc8e1500e7af220787"
    sha256 cellar: :any_skip_relocation, big_sur:        "12db971a1eb1d567c1438c476c69a01ace6c3cf08cc0eefc8e1500e7af220787"
    sha256 cellar: :any_skip_relocation, catalina:       "12db971a1eb1d567c1438c476c69a01ace6c3cf08cc0eefc8e1500e7af220787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b06295008315e99212e35a1c8534897362c3a96311f92980d88dec2aaf8e4fd2"
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
