class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.7.5/easyengine.phar"
  sha256 "917db51ea1accb1dda7ee9a558925e2a769754723d5a66cb5291ec29d97ebfb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f663af02201672cfc783ae40a52689b30e986bbe1adec575e6b38adc5ec19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f663af02201672cfc783ae40a52689b30e986bbe1adec575e6b38adc5ec19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f663af02201672cfc783ae40a52689b30e986bbe1adec575e6b38adc5ec19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "45605433322b11f53114776623fd1907f26112962cd75b98af760f575a298185"
    sha256 cellar: :any_skip_relocation, ventura:       "45605433322b11f53114776623fd1907f26112962cd75b98af760f575a298185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0c4704ffe272b25eb890cd9f93f06cc3c42f40294f0f4ed1e27d6d73c50e25"
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
