class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://pauljuliusmartinez.github.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "8b36d117ac0ef52fa0261e06b88b5ae77c2ff4beeb54f2c906a57f066dc46179"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/jless", "--help"
  end
end
