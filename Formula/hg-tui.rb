class HgTui < Formula
  desc "使用 TUI 界面去浏览 HelloGitHub 网站"
  homepage "https://github.com/kaixinbaba/hg-tui"
  url "https://github.com/kaixinbaba/hg-tui/archive/0.1.4.tar.gz"
  sha256 "8bed6a213760dff1d09d7a043e49491e8383322ac1b1dc2ef585e9e113d0d5cd"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"hgtui", "--version"
  end
end
