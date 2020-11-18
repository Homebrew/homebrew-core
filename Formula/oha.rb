class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.4.tar.gz"
  sha256 "e40fa987e0a2ab8f04b00ea90892b0ccdcecbb2e8d2cafc2ca318aa44a7dcf03"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de9c52c82955474dd3b78e873380bf675b714dbdba6218ef7d6ae06b29881c63" => :big_sur
    sha256 "f80eb1966814076e9797d643df28d2dbeaa1950592a848e04384d77b4f8a83ac" => :catalina
    sha256 "17c209ef3dce876112a23c98c45bfe03c5431ca6237df22b09b96868de4ced3a" => :mojave
    sha256 "268ceb293e2fad376373f1d177ad6aff768bfdcf5e24bf8db7583f561f92fa2b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
