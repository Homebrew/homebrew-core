class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.7.1/easyengine.phar"
  sha256 "0914538b7beef0e32d8e20ebf8a7a4c49b29604da5eb972e0e294c5e3779449c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2446011b20a7eff6b87897f26cea84cda8cc28668cc8bf2c90e26e93dc2c4160"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2446011b20a7eff6b87897f26cea84cda8cc28668cc8bf2c90e26e93dc2c4160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2446011b20a7eff6b87897f26cea84cda8cc28668cc8bf2c90e26e93dc2c4160"
    sha256 cellar: :any_skip_relocation, sonoma:         "29efb49725fa350412212f60dc15c7c927332570060fa38b273f932611f41006"
    sha256 cellar: :any_skip_relocation, ventura:        "29efb49725fa350412212f60dc15c7c927332570060fa38b273f932611f41006"
    sha256 cellar: :any_skip_relocation, monterey:       "29efb49725fa350412212f60dc15c7c927332570060fa38b273f932611f41006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2d3f8cb1d672b25e62fc7e455fb7c78bdbac41f716c530c282a8814898e4db"
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
