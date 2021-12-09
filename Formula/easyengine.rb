class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.0/easyengine.phar"
  sha256 "dcbbdf146d013d72436ba1904e10e4ca09a68deed03a402d14503c35c116117a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595c940f11f4fb06a2aabdcaee30238f2ec42e9cdbe5d1be8bc602b566042392"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "595c940f11f4fb06a2aabdcaee30238f2ec42e9cdbe5d1be8bc602b566042392"
    sha256 cellar: :any_skip_relocation, monterey:       "32bf71f65354ffaef73d7ffba8ac8a93394d0502379c7074b46c9331c3f6a121"
    sha256 cellar: :any_skip_relocation, big_sur:        "32bf71f65354ffaef73d7ffba8ac8a93394d0502379c7074b46c9331c3f6a121"
    sha256 cellar: :any_skip_relocation, catalina:       "32bf71f65354ffaef73d7ffba8ac8a93394d0502379c7074b46c9331c3f6a121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595c940f11f4fb06a2aabdcaee30238f2ec42e9cdbe5d1be8bc602b566042392"
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
