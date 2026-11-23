class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.15.0/easyengine.phar"
  sha256 "e14403bdb94570c8a26a58094956f155688969b9fb30dd64f85846116e490f79"
  license "MIT"

  bottle do
    manifest_sha256 "77aadad4960ae50f099b6959c6f415dc2236f48e3e4cae794eaf61933ccaf259"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c57027da50c26ccff0a915c48a699aa775f11a76c08df42fe3a923d575c3531"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c57027da50c26ccff0a915c48a699aa775f11a76c08df42fe3a923d575c3531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c57027da50c26ccff0a915c48a699aa775f11a76c08df42fe3a923d575c3531"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fed875ef20034540a45f6b791880cea45abb8189f402185e5d44cc318b3205b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fed875ef20034540a45f6b791880cea45abb8189f402185e5d44cc318b3205b3"
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
