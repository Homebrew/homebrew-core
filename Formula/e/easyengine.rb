class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.11.0/easyengine.phar"
  sha256 "bc13a129586fcb734c85e386199d7fc2f1496112071be72235cdfb78deb725fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d0514efbeb5e84e32500e0fb7f17b368c4a14a7a2378e8a83f07fc0c4679f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d0514efbeb5e84e32500e0fb7f17b368c4a14a7a2378e8a83f07fc0c4679f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d0514efbeb5e84e32500e0fb7f17b368c4a14a7a2378e8a83f07fc0c4679f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25df9d02a646dbcc1a76d3b4d054e89c656428a85fbcf818d52643b5687ed6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f25df9d02a646dbcc1a76d3b4d054e89c656428a85fbcf818d52643b5687ed6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25df9d02a646dbcc1a76d3b4d054e89c656428a85fbcf818d52643b5687ed6b"
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
