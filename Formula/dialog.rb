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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3426b2e8d639857b7c7b4ff8cfd7d1b907d40e9b52268e3cde2c6fca860bae8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "38bdd48f63fded5254924dda25fdc060c96bc0cb9181068bc54326212f065ccc"
    sha256 cellar: :any_skip_relocation, catalina:      "f40fc293690fcda948cec968736b8b08120ad46262a65324ff3ff86f5ef91fae"
    sha256 cellar: :any_skip_relocation, mojave:        "ce1ff4e4585bd9b656ea533f1fc04ca398ff4d8fc0879389ec7d13470ac74b41"
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
