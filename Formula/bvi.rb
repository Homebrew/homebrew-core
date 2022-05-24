class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bvi/bvi/1.4.1/bvi-1.4.1.src.tar.gz"
  sha256 "3035255ca79e0464567d255baa5544f7794e2b7eb791dcc60cc339cf1aa01e28"
  license "GPL-3.0"

  bottle do
    sha256 arm64_monterey: "a8a313fa812ea288a6a317cb5b3bf255e19180f0fbb568401ab48188594545e5"
    sha256 arm64_big_sur:  "5e71e7f93fd8523543f85723621ca80faa67482ba01019eddcc0408e95a0b21d"
    sha256 monterey:       "fec4cc7e517b1ee4810e76e4affcf724dea696dbea9fed3bcc0a1063e385ecac"
    sha256 big_sur:        "cc03571d7931314c6fbe6adacace77b4d6b5204b6c34d57da40f45915f84b1db"
    sha256 catalina:       "83cfa7a1fe8848d8eab7f01da94a32e75eb7c57221854a3f3f06a05417975977"
    sha256 mojave:         "567e9512dfd4fcf7768c442a6e609f7b798b887e4cdd59c1b38970940b9c528f"
    sha256 high_sierra:    "28ba5db61217dfe797423fd55b5fce06def1d5760aa466685759f1e315459777"
    sha256 x86_64_linux:   "39c71fb5ee3d1ed093cfd83332419494c0a4152fd7d75ed4aa7fa2d9f2ee6dc9"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bvi", "-c", "q"
  end
end
