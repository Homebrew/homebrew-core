class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.4.1/easyengine.phar"
  sha256 "1554946f9e14165a9f25babde85941ee8a9f834a1d2b8364126fe36be596dbc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01b1cf76c7de7d19048831b18052fcee01907372b350572d318acf606024f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dadda808adbe3b36846613fcd9940ac087159aff9688452bf570df183eff6e7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc91f8e425f8f6346cc0baf1dc5b8501288945854c86ecc3837a220be8415c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, catalina:       "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, mojave:         "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
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
