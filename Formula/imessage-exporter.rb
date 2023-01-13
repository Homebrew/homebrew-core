class ImessageExporter < Formula
  desc "Export MacOS iMessage data + run iMessage Diagnostics"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/0.1.9.tar.gz"
  sha256 "033789e51e3621a74b19e4a5339f0e0b65c2d33b8c3e367a5f7fbd1cdfa642e7"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_equal "fake is not a valid export type! Must be one of <txt, html>\n", shell_output("imessage-exporter -f fake")
    assert_equal "Diagnostics are enabled; format is disallowed\n", shell_output("imessage-exporter -f txt -d")
    assert_equal "No export type selected, required by no-copy\n", shell_output("imessage-exporter -n")
    assert_equal "No export type selected, required by export-path\n", shell_output("imessage-exporter -o fake")
    assert_equal "", shell_output("imessage-exporter -p fake")
  end
end
