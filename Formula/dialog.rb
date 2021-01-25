class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20210117.tgz"
  sha256 "3c1ed08f44bcf6f159f2aa6fde765db94e8997b3eefb49d8b4c86691693c43e1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "677d2554e2edadf745696c9071287cf34e567bc1247e780de08ca4e8150901cd" => :big_sur
    sha256 "bf1cf9dd2d58d9548899df78a3e17db59a81c78c372c1027eb031195b70cc53a" => :arm64_big_sur
    sha256 "572b7a9d28c5ba6b064ae85ee21f294e7e1c0f7e7f9a56a13d77ee55f30a2175" => :catalina
    sha256 "aaae8bb17a8e2d3b2f62d305cf9e054e9d5c47ab1ce31b4546d677ad01e7b8a1" => :mojave
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
