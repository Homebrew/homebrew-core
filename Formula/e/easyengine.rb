class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.13.2/easyengine.phar"
  sha256 "e47cc3cdf33be54008126e2c07e7a685dbc9ca5c1da8718e8430da83468a698b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bb24e95d9b1b46ae7279ddfcce8674f1c64a4a6a6e85560d1232150b1e021da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bb24e95d9b1b46ae7279ddfcce8674f1c64a4a6a6e85560d1232150b1e021da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bb24e95d9b1b46ae7279ddfcce8674f1c64a4a6a6e85560d1232150b1e021da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2b9315e5b97f0269a9d17f3a5dc707ee58896569b2c6c63dd113e8b9dcee6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b2b9315e5b97f0269a9d17f3a5dc707ee58896569b2c6c63dd113e8b9dcee6c3"
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
