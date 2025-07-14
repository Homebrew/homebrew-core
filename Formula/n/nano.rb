class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.5.tar.xz"
  sha256 "000b011d339c141af9646d43288f54325ff5c6e8d39d6e482b787bbc6654c26a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a2c6f7d2abf651c5e9fa12e464738db4d7cf3ed3ada7d9ad0a13a2d9fce66b39"
    sha256 arm64_sonoma:  "dbbdc447e9a165a723e5f2395804c8fd824bea746527e34fde490d0a87b29bca"
    sha256 arm64_ventura: "c24147006511132f233eaa658ae8a61e66ca4acddf7714b63685ac49256f5940"
    sha256 sonoma:        "3eeade09e4f74e9bd34d74fa7fbc6e761a342bc2035e659bce0dff2b36426c5d"
    sha256 ventura:       "cdfadb0cfa473d0c65b40f2436af6a917f0c8c02014b329b685e2adfd16a0c8c"
    sha256 arm64_linux:   "e710f0ffc9b17c3ab17a5feef2ba81f66adf0f2c93847c70bcb880f720578c2a"
    sha256 x86_64_linux:  "3182fc3818321fe0b974a25b53684f4209fb8711498ebbda81bd9739affce571"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system bin/"nano", "--version"
  end
end
