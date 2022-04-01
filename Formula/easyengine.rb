class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.4/easyengine.phar"
  sha256 "c5ea2539a0ce40d8927c36878ec7c1ebf7184397f10586c2a030ec498cafb429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd789e482ec01d3a81c35cf667e2e5f347ab5e4b9d25b23fc6e301dfb04ffa22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd789e482ec01d3a81c35cf667e2e5f347ab5e4b9d25b23fc6e301dfb04ffa22"
    sha256 cellar: :any_skip_relocation, monterey:       "718cad356c16de1833ceb664d530b8a4b9463306e2f5285bf5fa76851d6ea872"
    sha256 cellar: :any_skip_relocation, big_sur:        "718cad356c16de1833ceb664d530b8a4b9463306e2f5285bf5fa76851d6ea872"
    sha256 cellar: :any_skip_relocation, catalina:       "718cad356c16de1833ceb664d530b8a4b9463306e2f5285bf5fa76851d6ea872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd789e482ec01d3a81c35cf667e2e5f347ab5e4b9d25b23fc6e301dfb04ffa22"
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
