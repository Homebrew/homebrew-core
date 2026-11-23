class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.15.0/easyengine.phar"
  sha256 "e14403bdb94570c8a26a58094956f155688969b9fb30dd64f85846116e490f79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30c30fcb0114a535f4ebae8cbd2a011b232d3f9ec9ca327caf5ece5730092796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30c30fcb0114a535f4ebae8cbd2a011b232d3f9ec9ca327caf5ece5730092796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30c30fcb0114a535f4ebae8cbd2a011b232d3f9ec9ca327caf5ece5730092796"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65bb6fb7110d348f576f479065f0eec5bc339ae467d4fef317f3720373992ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "65bb6fb7110d348f576f479065f0eec5bc339ae467d4fef317f3720373992ed4"
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
