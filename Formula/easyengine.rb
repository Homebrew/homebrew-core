class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.2/easyengine.phar"
  sha256 "37cbe42a44ba4dd86e8aaa952df554f008e0cce97a86661fc7f5e30febc83ac8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac94715aa091ef1016f5e11637ec328e266719161d340c7c834f9aadc7bb951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bac94715aa091ef1016f5e11637ec328e266719161d340c7c834f9aadc7bb951"
    sha256 cellar: :any_skip_relocation, monterey:       "09a235e34a9ecf5719782b2a230898054b2711bf8da69e1fd5a5faee4c45c2d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "09a235e34a9ecf5719782b2a230898054b2711bf8da69e1fd5a5faee4c45c2d1"
    sha256 cellar: :any_skip_relocation, catalina:       "09a235e34a9ecf5719782b2a230898054b2711bf8da69e1fd5a5faee4c45c2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac94715aa091ef1016f5e11637ec328e266719161d340c7c834f9aadc7bb951"
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
