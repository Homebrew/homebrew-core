class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.6.tar.gz"
  sha256 "81007141b3cb5d06d5b7283845f0b853cdb9c9a5f4feaaf223d5d2bfbb07bfb7"

  bottle do
    sha256 "e9bc20edf4cb803e19698c852c04b16fd80aa65cc13dd038325118ef9e030749" => :catalina
    sha256 "c45f47c1154978ac59410cbda1da83fa76d58b9ad13fbdbed0b6d6e721b6fe77" => :mojave
    sha256 "1c09e84ea1a05180a5acbd56f0f738bca4742f9cc834a0586685d47f59c57902" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  # Reported upstream at https://savannah.gnu.org/bugs/index.php?57367
  # Fixed upstream at https://git.savannah.gnu.org/cgit/nano.git/commit/?id=f516cddce749c3bf938271ef3182b9169ac8cbcc
  # Remove patch in next update.
  patch do
    url "https://savannah.gnu.org/file/0001-build-fix-compilation-on-macOS-where-st_mtim-is-unkn.patch?file_id=48016"
    sha256 "c30e10bb5c5df739c51e7a91c66bf8ebef52709e463c8717f292292daf5aebc9"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
