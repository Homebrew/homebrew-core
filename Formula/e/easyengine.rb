class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.6/easyengine.phar"
  sha256 "4831c9bd224b1dca1cb40d1a519c3578d2c508cb55fb8464f3d1e5224aef5583"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2312f368f0a628c919bd03158f6089c84dc7b8e6ff45997e401491f428c8840"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "082306fcc2974440b5d709e6d21b39c8f1f435ef7540c87826425fade1100c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082306fcc2974440b5d709e6d21b39c8f1f435ef7540c87826425fade1100c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "082306fcc2974440b5d709e6d21b39c8f1f435ef7540c87826425fade1100c2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d93fc9c2c357998d3e9eec42c8a4ac09da9f3867952fac9355d4d97e40b0c549"
    sha256 cellar: :any_skip_relocation, ventura:        "d2ab3a3af702e3c2ae9424cdf5deb6f991782db76d2d47b2046fe2f57cb45b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ab3a3af702e3c2ae9424cdf5deb6f991782db76d2d47b2046fe2f57cb45b8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2ab3a3af702e3c2ae9424cdf5deb6f991782db76d2d47b2046fe2f57cb45b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082306fcc2974440b5d709e6d21b39c8f1f435ef7540c87826425fade1100c2c"
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
