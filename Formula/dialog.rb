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
    sha256 "eb3455238be98e27905b275e88723a0e0ccee0c959ca1124ba681728626e08b6" => :big_sur
    sha256 "1123439be33e07dafe32f34271445d3e3a7d7d00aa21f4141ba8a7d88a5164da" => :arm64_big_sur
    sha256 "6fc24c87e6cf32e7702c0f9e64eba5ad79908b84bf1614cc62a99c967bb659ea" => :catalina
    sha256 "0bb780acdabb6d05e8e6465fa8f204758a27c39caf7fc93fa9e5da17dcfeac31" => :mojave
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
