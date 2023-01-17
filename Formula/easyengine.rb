class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.5/easyengine.phar"
  sha256 "2477012abffeefe8b4008d669e0e632d086d3e7cdc2db6f04e5495355df6eb62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad2f8b85d4c31b21d66243ef1e26cfa87494006d5d4a3e3dbdd953c1b42bf31b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2f8b85d4c31b21d66243ef1e26cfa87494006d5d4a3e3dbdd953c1b42bf31b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad2f8b85d4c31b21d66243ef1e26cfa87494006d5d4a3e3dbdd953c1b42bf31b"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3e2612c1112123ead5f08031df7c1a85c28589d1c467baa626d2d7a22d6501"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3e2612c1112123ead5f08031df7c1a85c28589d1c467baa626d2d7a22d6501"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3e2612c1112123ead5f08031df7c1a85c28589d1c467baa626d2d7a22d6501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2f8b85d4c31b21d66243ef1e26cfa87494006d5d4a3e3dbdd953c1b42bf31b"
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
