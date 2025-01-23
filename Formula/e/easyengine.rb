class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.8.0/easyengine.phar"
  sha256 "5002134b0a9940c0e9466a2ea9d981d77478034398352117952a1a71d73a4406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21949eec79b6bb562a6806bc3dc6886493b6c46e074ea8bee7e5d4281d079a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21949eec79b6bb562a6806bc3dc6886493b6c46e074ea8bee7e5d4281d079a7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21949eec79b6bb562a6806bc3dc6886493b6c46e074ea8bee7e5d4281d079a7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3773f8ae8284af58899f0233bdf508de336297220563c52f08e37ff8cbf8646"
    sha256 cellar: :any_skip_relocation, ventura:       "a3773f8ae8284af58899f0233bdf508de336297220563c52f08e37ff8cbf8646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0fe84d9a9117825edb55e597598a39b20e4ea44366f04495842f3145e5bebb8"
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
