class MacosUpdate < Formula
  desc "CLI tool for handling macOS software updates"
  homepage "https://github.com/owenlejeune/macOS-update"
  url "https://github.com/owenlejeune/macOS-update/archive/v1.0.tar.gz"
  sha256 "2f01b12015f0aafead28b7b90c4dd44190d76883a09af58a6aa0f9459256b2e7"

  def install
    bin.install "macosupdate"
  end

  test do
    system "#{bin}/macosupdate", "list"
  end
end
