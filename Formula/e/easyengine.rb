class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.12.0/easyengine.phar"
  sha256 "867bf82e1b583a807b1d1efa3a7cb40abc789d7a1a193397eb6d4a3301307aac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f37ec3f1ccd11901ea14f64a5b00762174880c36c319d6bd4d66f3844dd0273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f37ec3f1ccd11901ea14f64a5b00762174880c36c319d6bd4d66f3844dd0273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f37ec3f1ccd11901ea14f64a5b00762174880c36c319d6bd4d66f3844dd0273"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bcca14b0293f51b8e43f59f0acf3475d7db93b93091b808a3cc9f3a7acb63b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcca14b0293f51b8e43f59f0acf3475d7db93b93091b808a3cc9f3a7acb63b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcca14b0293f51b8e43f59f0acf3475d7db93b93091b808a3cc9f3a7acb63b3"
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
