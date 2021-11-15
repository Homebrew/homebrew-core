class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/1.27.0/phpbrew.phar"
  sha256 "0fdcda638851ef7e306f5046ff1f9de291443656a35f5150d84368c88aa7a41a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334ce2bf2192727172bbb2bc449b028e27419b4ed6d076d759ef459f30c76225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7284fc0683ff84b048b9ceb72a3e810aa250086a766dd0a44f3dc57a53c073b"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b4ec02efb50c18f7ddc1c4b341fd7ef954c7af9b779a4a705b67b299978135"
    sha256 cellar: :any_skip_relocation, big_sur:        "da1a09ea403685c424d6808c9486a76182ca29e689243ae703f4f9e0820b756a"
    sha256 cellar: :any_skip_relocation, catalina:       "da1a09ea403685c424d6808c9486a76182ca29e689243ae703f4f9e0820b756a"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    chmod "+x", "phpbrew.phar"
    bin.install "phpbrew.phar" => "phpbrew"
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
