class Clavirio < Formula
  desc "Terminal typing tutor built with Rust and ratatui"
  homepage "https://www.clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "71a869c297a35e5cdd8ac6972e3709c34aca658c47adc711fdae8c19a58da73e"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_path_exists bin/"clavirio", :exist?
    assert_predicate bin/"clavirio", :executable?
  end
end
