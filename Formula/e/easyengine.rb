class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.10.2/easyengine.phar"
  sha256 "7fcf21ac7cb8ea42295fa4b9617436de40b2fbbe1202bdc001c0cf5d5af9fa1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f5cdff945a1a1f6eb20d56964a207870bbd9479d823162f5cd85765e5da2f8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5cdff945a1a1f6eb20d56964a207870bbd9479d823162f5cd85765e5da2f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5cdff945a1a1f6eb20d56964a207870bbd9479d823162f5cd85765e5da2f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d35791db595e47d9df99820915b1e76e4e550d6e6af302b6138e4d36900e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d35791db595e47d9df99820915b1e76e4e550d6e6af302b6138e4d36900e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d35791db595e47d9df99820915b1e76e4e550d6e6af302b6138e4d36900e09"
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
