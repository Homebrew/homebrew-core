class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.14.1/easyengine.phar"
  sha256 "3d1b463897419723b4add2fc5b18aef3261870a621c111b4a834183a6137015e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "574efcc789e8798fda9723a678a6ec5f1a4f416e18f28c2ce2047e3c9dac27a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "574efcc789e8798fda9723a678a6ec5f1a4f416e18f28c2ce2047e3c9dac27a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "574efcc789e8798fda9723a678a6ec5f1a4f416e18f28c2ce2047e3c9dac27a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23f37036cd729bf4888ef74eaf3d893abc5672d7350a1939d3e45bc27f84e2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "23f37036cd729bf4888ef74eaf3d893abc5672d7350a1939d3e45bc27f84e2fd"
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
