class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.9.0/easyengine.phar"
  sha256 "d59bfaaa42c5d51360d1194c1620ba2a2ac9611a95a7ff7c51f4afb66145bb26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6d7e03ccf108f057da5b3135be1bc522cd9c7725b09d47c20060a22341d3ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d7e03ccf108f057da5b3135be1bc522cd9c7725b09d47c20060a22341d3ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6d7e03ccf108f057da5b3135be1bc522cd9c7725b09d47c20060a22341d3ba8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe6fee62fefc97a888faaddbaf5b057087b69f790fb2af1659200d074fe70291"
    sha256 cellar: :any_skip_relocation, ventura:       "fe6fee62fefc97a888faaddbaf5b057087b69f790fb2af1659200d074fe70291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56027e5af76a364d550e33a20a9022a9e7052617d0933750cd6298166e9a4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56027e5af76a364d550e33a20a9022a9e7052617d0933750cd6298166e9a4bb"
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
