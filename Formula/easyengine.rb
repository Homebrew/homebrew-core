class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.3/easyengine.phar"
  sha256 "3780418c258247a69ccd0f3d7bee7ed550910ab298bfbfaf49c9c330ce014d45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "852e3649252249f14da6e3fae2122b80aed20253c77d51488a1ce0e9d8533a65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "852e3649252249f14da6e3fae2122b80aed20253c77d51488a1ce0e9d8533a65"
    sha256 cellar: :any_skip_relocation, monterey:       "998337c467b3e9b50fa53de78729d8f3a59baca0b067102602e17e7365c21634"
    sha256 cellar: :any_skip_relocation, big_sur:        "998337c467b3e9b50fa53de78729d8f3a59baca0b067102602e17e7365c21634"
    sha256 cellar: :any_skip_relocation, catalina:       "998337c467b3e9b50fa53de78729d8f3a59baca0b067102602e17e7365c21634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "852e3649252249f14da6e3fae2122b80aed20253c77d51488a1ce0e9d8533a65"
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
