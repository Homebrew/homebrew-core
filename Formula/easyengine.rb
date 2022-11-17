class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.2/easyengine.phar"
  sha256 "857c72d1007f8a85e6bdf02b20e55154d1877e53bd0ec5c2e46c7d7b54d660f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49dbdeaa32eeb010f154fd0db1c3015a752339eafcd10657abe46bb66a89b89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a49dbdeaa32eeb010f154fd0db1c3015a752339eafcd10657abe46bb66a89b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a49dbdeaa32eeb010f154fd0db1c3015a752339eafcd10657abe46bb66a89b89"
    sha256 cellar: :any_skip_relocation, monterey:       "6fbe7dfcdba82deeaeb9552fe2e52c299add61cba3df8b5ca717dcb62333ae41"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fbe7dfcdba82deeaeb9552fe2e52c299add61cba3df8b5ca717dcb62333ae41"
    sha256 cellar: :any_skip_relocation, catalina:       "6fbe7dfcdba82deeaeb9552fe2e52c299add61cba3df8b5ca717dcb62333ae41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49dbdeaa32eeb010f154fd0db1c3015a752339eafcd10657abe46bb66a89b89"
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
