class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.14.0/easyengine.phar"
  sha256 "45b5558a3ab56bb1dfc5482fcc6d509fa689422e2d0d121bc309fdb8893a098d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69a12121cc9a2e48e2e5901003e10e02dd0cc99a1082cc418c708a4f0e52e502"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69a12121cc9a2e48e2e5901003e10e02dd0cc99a1082cc418c708a4f0e52e502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69a12121cc9a2e48e2e5901003e10e02dd0cc99a1082cc418c708a4f0e52e502"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfafadefd9b8ee7e21268b2f32422a556d544bb522a3cd71f4cafd3d394013e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cfafadefd9b8ee7e21268b2f32422a556d544bb522a3cd71f4cafd3d394013e4"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  deny_network_access!

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
