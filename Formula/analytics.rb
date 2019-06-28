class Analytics < Formula
  desc "CLI tool for sending analytics events to segment.com"
  homepage "https://github.com/segmentio/analytics-rust"
  url "https://github.com/segmentio/analytics-rust/archive/0.2.0.tar.gz"
  sha256 "21b2178cf218ec46a07b429c1f17709504d4fcddb53686918f83861263cb69b6"
  head "https://github.com/segmentio/analytics-rust.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "cli"
  end

  test do
    system "#{bin}/analytics", "--help"
  end
end
