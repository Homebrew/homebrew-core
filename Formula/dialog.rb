class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20210530.tgz"
  sha256 "1f62df6a48dac087b98452119e4cdfcaa3447b3eb5746b241e5632e1d57bfc4b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c0a2d6c566c6e52b60f89473f2302fc358b5b0e7bdfcb56e68f4156b19935de"
    sha256 cellar: :any_skip_relocation, big_sur:       "efd474be5a0e0afeabb52e507e04340c6eecda2b27cce99a9c33c0f5ed20e47d"
    sha256 cellar: :any_skip_relocation, catalina:      "0d0443b814de110ad082853b803476292507d8e069316e2280097ad5985ab768"
    sha256 cellar: :any_skip_relocation, mojave:        "823a60bde7692ba06fedd66b95fa7eee00d36ad327bfa6c2047018e234eddb1a"
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
