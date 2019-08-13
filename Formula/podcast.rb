class Podcast < Formula
  desc "Command line podcast player"
  homepage "https://github.com/njaremko/podcast"
  url "https://github.com/njaremko/podcast/archive/0.12.1.tar.gz"
  sha256 "18e401751729c6844f43298c1da934fc6d1379da20cc4287ea4dee6ed6a26522"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/podcast", "subscribe", "http://feeds.feedburner.com/mbmbam"
    assert_match "My Brother, My Brother And Me",
                 shell_output("#{bin}/podcast", "ls")
  end
end
