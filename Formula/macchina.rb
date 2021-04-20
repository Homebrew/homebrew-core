class Macchina < Formula
  desc "A system information fetcher, with an emphasis on performance and minimalism."
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.7.0.tar.gz"
  sha256 "6ff1497864a400f5eade2b46984cbe1259a0f7a75bf7191a2a75e111a8ffe119"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
