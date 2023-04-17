class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "63ffceb01551fbbe920ee59f1b935f72ca55785edffc490efaedfbe1799ed8d2"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/dezoomify-rs --help")
  end
end
