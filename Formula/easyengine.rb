class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.3.1/easyengine.phar"
  sha256 "125a80fe3f0e067cbc5add818b92e12b5208179ed0e6d493872e3a9d59b1eecc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6dadda808adbe3b36846613fcd9940ac087159aff9688452bf570df183eff6e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, catalina:      "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, mojave:        "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
  end

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  pour_bottle? do
    on_macos do
      reason "The bottle needs to be installed into `#{Homebrew::DEFAULT_PREFIX}` on Intel macOS."
      satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX || Hardware::CPU.arm? }
    end
  end

  depends_on "dnsmasq"
  depends_on "php"

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    system bin/"ee config set locale hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match "Darwin", output
  end
end
