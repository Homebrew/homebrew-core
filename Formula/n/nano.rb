class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.0.tar.xz"
  sha256 "c17f43fc0e37336b33ee50a209c701d5beb808adc2d9f089ca831b40539c9ac4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ab6d8ae45dee1875b9136ce8706e50e635228d1eae5922de1eb670ba64761f9d"
    sha256 arm64_ventura:  "f6f0afe75cbf9529e2c81c71716c4c4d05345bf748b00211d2372aeb3c5ad985"
    sha256 arm64_monterey: "2bcc218d8cb4ae4f607309c1ad2cbdc2125452e32249dc2b6742ea6480c96d82"
    sha256 sonoma:         "b6742b64675f000c999755604e57af1e36eb316986df5595d50a2559612efc87"
    sha256 ventura:        "6f3670dda30f0eef25b1b864c2f60e9a8fa499b014c16ce52caba673ece99fc0"
    sha256 monterey:       "c3ffa947c3be3fe029c0adb48bc2670eb0c4cdbdfc93ed73ce146f36ba94b4da"
    sha256 x86_64_linux:   "478eb3658dd8d8fa19fdec2f43dcf2cb457f0aa09fde583c951c913398ed5061"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
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
