class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://github.com/mhzawadi/homebrew-cbonsai"
  url "https://github.com/mhzawadi/homebrew-cbonsai/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "c2e603c24afc5900ce0f2e98fd86aee75d8ef1f81b52410227465193e246b481"
  license "GPL-3.0"
  depends_on "ncurses"
  depends_on "pkg-config"

  def install
    ENV["PKG_CONFIG_PATH"] = "$PKG_CONFIG_PATH:/usr/local/Cellar/ncurses/6.4/lib/pkgconfig/"
    ENV.append_path "PKG_CONFIG_PATH", "/opt/homebrew/Cellar/ncurses/6.4/lib/pkgconfig/"
    system "make"
    bin.install "cbonsai"
  end

  test do
    system "~/.local/bin/cbonsai", "-p"
  end
end
