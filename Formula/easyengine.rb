class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.6.0/easyengine.phar"
  sha256 "d11c9de04ee71b0bd138694e3795a875b4580826a351d2e8605e0857d5b4eaed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec39d3a729c7f058b5b9e5a1edc6dfa76352fb42a895688840be2b2efc7f1f4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec39d3a729c7f058b5b9e5a1edc6dfa76352fb42a895688840be2b2efc7f1f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "deb8109d5f9d18021f39e2821e4dfea2084f53f1b3760b88ab6c075027327080"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb8109d5f9d18021f39e2821e4dfea2084f53f1b3760b88ab6c075027327080"
    sha256 cellar: :any_skip_relocation, catalina:       "deb8109d5f9d18021f39e2821e4dfea2084f53f1b3760b88ab6c075027327080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec39d3a729c7f058b5b9e5a1edc6dfa76352fb42a895688840be2b2efc7f1f4a"
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
