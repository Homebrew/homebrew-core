class Grsync < Formula
  desc "GUI for rsync"
  homepage "http://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.6.tar.gz"
  sha256 "66d5acea5e6767d6ed2082e1c6e250fe809cb1e797cbbee5c8e8a2d28a895619"

  bottle do
    sha256 "c35defcfcef7d9f1af5c8fd82c95733d1d0191e7c9a338f9223744e55adf32de" => :sierra
    sha256 "d0afd0d818a8c4a72368c85d1123f76997470c16c2ab38ed78b6e1b977c7b691" => :el_capitan
    sha256 "7046b8ffefa83d5a153ecd75d9255813b95e325595c712bec1d0a11727f70017" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert (bin/"grsync").exist?
  end
end
