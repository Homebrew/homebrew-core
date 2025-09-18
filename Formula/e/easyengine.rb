class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.9.2/easyengine.phar"
  sha256 "9ab928c4e5795a456386b4f30faa0d1c1ce4c4d4dfbbb245e9b4ac40d35b0ab8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0322877b6f137dc95bc06d13ef94398a5ed2e72d6c3da8e76b4b5b728183359f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0322877b6f137dc95bc06d13ef94398a5ed2e72d6c3da8e76b4b5b728183359f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0322877b6f137dc95bc06d13ef94398a5ed2e72d6c3da8e76b4b5b728183359f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0322877b6f137dc95bc06d13ef94398a5ed2e72d6c3da8e76b4b5b728183359f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce400d86fe8ca8b4c623bba109a64e3b5cfb02290b4c82f77a449499bbf993e"
    sha256 cellar: :any_skip_relocation, ventura:       "4ce400d86fe8ca8b4c623bba109a64e3b5cfb02290b4c82f77a449499bbf993e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce400d86fe8ca8b4c623bba109a64e3b5cfb02290b4c82f77a449499bbf993e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce400d86fe8ca8b4c623bba109a64e3b5cfb02290b4c82f77a449499bbf993e"
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
