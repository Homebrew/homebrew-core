class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.io"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.1.src.tar.gz"
  sha256 "3035255ca79e0464567d255baa5544f7794e2b7eb791dcc60cc339cf1aa01e28"

  bottle do
    sha256 "83cfa7a1fe8848d8eab7f01da94a32e75eb7c57221854a3f3f06a05417975977" => :catalina
    sha256 "567e9512dfd4fcf7768c442a6e609f7b798b887e4cdd59c1b38970940b9c528f" => :mojave
    sha256 "28ba5db61217dfe797423fd55b5fce06def1d5760aa466685759f1e315459777" => :high_sierra
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
