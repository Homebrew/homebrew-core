class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220117.tgz"
  sha256 "754cb6bf7dc6a9ac5c1f80c13caa4d976e30a5a6e8b46f17b3bb9b080c31041f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "101c9324bb0b82d5326e3e72b5be83eb8d2ca88c9fd6e9afdb551ddcc1df8b31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9cf67b61d3a036ff22c4fc59a85df6e376a13e01c6ab5fa802e8eb2753733fc"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0385b01594b7c3614c0b67c616df87dde676d814e45849e718a594c909568f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7162a6c5041dd65f65cbdfff8a8aa347c6fc3f374993e15f7b6833ce4f256599"
    sha256 cellar: :any_skip_relocation, catalina:       "bddb6d369ce0e44e159178c10db721c0cdcdb192c350a1959ff95b1192c0695a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9599836a02d3c84e5499c9d2de5071cb8edfd74553f56992a8c29f9ac8005f"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
