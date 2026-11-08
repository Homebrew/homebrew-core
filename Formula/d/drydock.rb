class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a22ee71cb99f98b6f3d2b769cccd7f629323c9f3463cbe1914de95c6042da229"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")

    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
