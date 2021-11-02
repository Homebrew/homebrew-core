class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.4.0/easyengine.phar"
  sha256 "fbec9321593c387a6d60c6a8b94b6804d0f71ce0fb83a29dc84b2a911eaf5b2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6dadda808adbe3b36846613fcd9940ac087159aff9688452bf570df183eff6e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, catalina:      "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
    sha256 cellar: :any_skip_relocation, mojave:        "e01550e56cc525492532558f554856f7925cd431234319715ee8a2a3caa0d32f"
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

  def caveats
    <<~EOS
      Hey there, we have recently introduced a feature which would allow you to create more than 27 sites.

      To enable it, you need to perform the following steps manually:

      1. Please open Docker Desktop and in taskbar, go to Preferences > Daemon > Advanced.
      2. If the file is empty, add the following:

      {
       "default-address-pools": [{"base":"10.0.0.0/8","size":24}]
      }

      If the file already contains JSON, just add the key "default-address-pools": [{"base":"10.0.0.0/8","size":24}]
      being careful to add a comma to the end of the line if it is not the last line before the closing bracket.

      3. Restart Docker
    EOS
  end

  test do
    system bin/"ee config set locale hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match OS.kernel_name, output
  end
end
