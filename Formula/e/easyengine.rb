class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.8.1/easyengine.phar"
  sha256 "81972cf29f232aa44f8a350de19c72305d9dc2483f5d5c136ee799de5acf00fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84686b1c691cd2ac72875708fbeefdede6d8a500255171c6b9ec6f8f9e95bb6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84686b1c691cd2ac72875708fbeefdede6d8a500255171c6b9ec6f8f9e95bb6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84686b1c691cd2ac72875708fbeefdede6d8a500255171c6b9ec6f8f9e95bb6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "daa06471a7126ea5f49edf3444e34d1398bcdbcb8e4cb63a3a67da76391b74a1"
    sha256 cellar: :any_skip_relocation, ventura:       "daa06471a7126ea5f49edf3444e34d1398bcdbcb8e4cb63a3a67da76391b74a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b88a26a83b12ddf035739411b78042e82cf88d150f747e724e1f774811127073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b88a26a83b12ddf035739411b78042e82cf88d150f747e724e1f774811127073"
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
