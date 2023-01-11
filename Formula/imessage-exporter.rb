class ImessageExporter < Formula
  desc "Export MacOS iMessage data + run iMessage Diagnostics"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/0.1.7.tar.gz"
  sha256 "0d54c614692795bf34a6e159c6e0eb7a61856aca0d72ce6efe7665c3b686ae6e"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--path", "imessage-exporter", "--locked", "--root", prefix
    bin.install "target/release/imessage-exporter"
  end

  test do
    system imessage-exporter
  end
end
