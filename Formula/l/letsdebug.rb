class Letsdebug < Formula
  desc "Diagnostics for Let's Encrypt SSL certificate issuance"
  homepage "https://letsdebug.net"
  url "https://github.com/letsdebug/letsdebug/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c2649b1d1902855c4798c8e6325127bcc6557bdceb68a2a23e89a86a2d191397"
  license "MIT"
  head "https://github.com/letsdebug/letsdebug.git", branch: "master"

  depends_on "go" => :build
  depends_on "unbound"

  def install
    system "go", "build", *std_go_args, "./cmd/cli/cli.go"
  end

  test do
    system "#{bin}/letsdebug", "-domain", "brew.sh"
  end
end
