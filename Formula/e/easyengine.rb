class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.7.3/easyengine.phar"
  sha256 "eb26a50b767a184c2017e3f4a87c145ed82a9299b1adffcdbf7c24ac5a488622"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e81967af526b1fa9be310f988a0eda4dc986edc67a3012f627024ea12f12b04c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81967af526b1fa9be310f988a0eda4dc986edc67a3012f627024ea12f12b04c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e81967af526b1fa9be310f988a0eda4dc986edc67a3012f627024ea12f12b04c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a937ff3388e011b9411df140e2fc7996ee16ee3fc3b4ea91a607f3a1eedc7938"
    sha256 cellar: :any_skip_relocation, ventura:        "a937ff3388e011b9411df140e2fc7996ee16ee3fc3b4ea91a607f3a1eedc7938"
    sha256 cellar: :any_skip_relocation, monterey:       "a937ff3388e011b9411df140e2fc7996ee16ee3fc3b4ea91a607f3a1eedc7938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d2c9973a3bc5d75448157c5e9e78f45a7748cbcff15c391e963e216d13f2d7"
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
