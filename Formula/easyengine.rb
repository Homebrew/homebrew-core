class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.4/easyengine.phar"
  sha256 "c5ea2539a0ce40d8927c36878ec7c1ebf7184397f10586c2a030ec498cafb429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "865b82d0801d3528a794a6dfc97987a8b4f33befe87af5c8b1e1ac36edfa2537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865b82d0801d3528a794a6dfc97987a8b4f33befe87af5c8b1e1ac36edfa2537"
    sha256 cellar: :any_skip_relocation, monterey:       "0568798846e2d3f5399bf19f78f1a5e66bc96c12fab1e5315edae68b14c60c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0568798846e2d3f5399bf19f78f1a5e66bc96c12fab1e5315edae68b14c60c6e"
    sha256 cellar: :any_skip_relocation, catalina:       "0568798846e2d3f5399bf19f78f1a5e66bc96c12fab1e5315edae68b14c60c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "865b82d0801d3528a794a6dfc97987a8b4f33befe87af5c8b1e1ac36edfa2537"
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
