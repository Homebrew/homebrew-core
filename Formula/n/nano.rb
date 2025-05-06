class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.4.tar.xz"
  sha256 "5ad29222bbd55624d87ea677928b3106a743114d6c6f9b41f36c97be2a8e628d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d2f5ea1b33cec52869da9ca76f2965254dc1b85fcf496d5754353ccadafc4bbd"
    sha256 arm64_sonoma:  "f17394e1f1723dea883838a5ffe80ca4d2936d90aec0ae978e1b170b99153286"
    sha256 arm64_ventura: "ccc99590f0bb5322c290c25da9df6ee50afeabcc7b46a0c5307ab46826363232"
    sha256 sonoma:        "8b32bd52654b34f36b0467c708682bc36e9ab88f136fc03c0ad420c757295b77"
    sha256 ventura:       "861c213bcbcfda215fd4e12957b8f06f2bb18e6b5f5f75e0b3e86e4f9dff9e67"
    sha256 arm64_linux:   "8eb34575f7aa47e1076a9c9225bd9997171f4a6db9961c5064bdcf7c993653f8"
    sha256 x86_64_linux:  "3fcf803e2e1e8b8b732f97bc45d1df1ce043f1a5cc3023194195dc53ac415627"
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
