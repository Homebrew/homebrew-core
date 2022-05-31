class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.5.6/easyengine.phar"
  sha256 "28cd198a6c66d646756e6bda7f0981d5677d935667e3c1afb9456348f5c128d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6f973203c022b6f280f0c78a37f79e6d770dfa5f26dc576ff33fa999969bb41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6f973203c022b6f280f0c78a37f79e6d770dfa5f26dc576ff33fa999969bb41"
    sha256 cellar: :any_skip_relocation, monterey:       "2261ec2571f602b39c61f521b2b5cf5929626887abfa184723e66bcf15ef9585"
    sha256 cellar: :any_skip_relocation, big_sur:        "2261ec2571f602b39c61f521b2b5cf5929626887abfa184723e66bcf15ef9585"
    sha256 cellar: :any_skip_relocation, catalina:       "2261ec2571f602b39c61f521b2b5cf5929626887abfa184723e66bcf15ef9585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f973203c022b6f280f0c78a37f79e6d770dfa5f26dc576ff33fa999969bb41"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
