class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "966c2c634fe8e4c30bec4be38a9bb1effcda06ef8496c94678c7e4192981f934"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed61e8c38d911774a3e7b2840324bad9203973297885997b88a494d44378f41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d434202d0eaedd2a9f41008cd1d77df2cbc0bdf1b9aa19a16e83f4a58a12ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c3b032f23f1f83182bff3bb1689ac01eafa9cd0f4792b23daeb380352cdd67e"
    sha256 cellar: :any_skip_relocation, ventura:        "e710e986769f9367d31f5f27b29a807ca96313c735b2c203e12ba0aed088ee2a"
    sha256 cellar: :any_skip_relocation, monterey:       "d1839a704ec6e33aeeb7ecfb07a9dcde1457ee6db1e8edc406fffef477ff75fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "675a93142d25ebc28dff6ee8a988750967ef458f08f478f6493d38d696080ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25dc1a75d6ba43c456d93f71c8bdc51d591f4c3d1128c7936866bdeb28ce350e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
