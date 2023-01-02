class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.4/easyengine.phar"
  sha256 "afbe968b2844705867c3e240c64d3b7cab7d253f2f167d564d34836eee20635f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b1c5e6afcf6737b9c2963a003b2c69a73debe7c571e88c88c728fb4891b032"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b1c5e6afcf6737b9c2963a003b2c69a73debe7c571e88c88c728fb4891b032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13b1c5e6afcf6737b9c2963a003b2c69a73debe7c571e88c88c728fb4891b032"
    sha256 cellar: :any_skip_relocation, ventura:        "4493789c9bea2d5b4180c4736b737bbd80f8972b6590bcf23588c372d62d9b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "4493789c9bea2d5b4180c4736b737bbd80f8972b6590bcf23588c372d62d9b1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4493789c9bea2d5b4180c4736b737bbd80f8972b6590bcf23588c372d62d9b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b1c5e6afcf6737b9c2963a003b2c69a73debe7c571e88c88c728fb4891b032"
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
