class Natls < Formula
  desc "⚡️ nat - the 'ls' replacement you never knew you needed⚡️"
  homepage "https://github.com/willdoescode/nat"
  url "https://github.com/willdoescode/nat/archive/v2.1.8.tar.gz"
  sha256 "cf71d0bfab2a2a0c3ee091c99044c9b177ad0162365af86eb62596648cd2b3f1"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/natls", "-v"
  end
end
