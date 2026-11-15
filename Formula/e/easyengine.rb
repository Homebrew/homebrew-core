class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.13.3/easyengine.phar"
  sha256 "13364d76ab4df809d9c70b080401df2b50ccca980c9044ffa9f56e6981a194ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95a009c0a6e83ed2659861aabdc45d503bc4cb8fa46a54b776070652a163c454"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95a009c0a6e83ed2659861aabdc45d503bc4cb8fa46a54b776070652a163c454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95a009c0a6e83ed2659861aabdc45d503bc4cb8fa46a54b776070652a163c454"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f23351e9bc0216d9e00dfc62913d13e6895cb5652a959c1cdaf8be4a4b802a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6f23351e9bc0216d9e00dfc62913d13e6895cb5652a959c1cdaf8be4a4b802a1"
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
