class MacosUpdater < Formula
  desc "Checks homebrew, macports, pkgsrc or nix, and updates outdated installations"
  homepage "https://github.com/dindin-glitch/macos-updater"
  url "https://github.com/dindin-glitch/macos-updater/archive/1.0.4.tar.gz"
  sha256 "b25a6e0d5b1f07cf23b493f3da215ab161fc91dff09ffa242827e4d08f861fbf"
  license "BSD-2-Clause"

  bottle :unneeded

  depends_on "mas"

  def install
    chmod "a+x", "configure"
    chmod "a+x", "macos-updater"
    system "./configure", bin.to_s
    chmod "a+x", "#{bin}/macos_updater"
  end

  test do
    system "macos-updater"
  end
end
