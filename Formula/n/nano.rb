class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.3.tar.xz"
  sha256 "551b717b2e28f7e90f749323686a1b5bbbd84cfa1390604d854a3ca3778f111e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "cbf8107bdd1dff5a6a2e8c42223b10398c92a62874a31a633e541e7cacb72256"
    sha256 arm64_sonoma:  "8aebff630cb1d0cf018239848c4bc6349d9bc80578229cd37fb1d4cf92b5df40"
    sha256 arm64_ventura: "5e2dd3eb0c19979b77595014a4d15c3f3a3286ccd22a72801274c2ee6df23512"
    sha256 sonoma:        "c2634f57ce9a9d7c342fc9778035c79285bfa37faa01f753e037bb5f14068ec4"
    sha256 ventura:       "ec4649d0625e95e3c6061bf97f81dd45199c9512663f0363744662eab83838d2"
    sha256 x86_64_linux:  "412fa6be2b3d91c3a15609d5e56ae88819d01e366a50895c4164101cc7cebd98"
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
