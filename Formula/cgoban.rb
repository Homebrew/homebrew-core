class Cgoban < Formula
  desc "Go-related services"
  homepage "http://www.igoweb.org/~wms/comp/cgoban/index.html"
  url "http://www.igoweb.org/~wms/comp/cgoban/cgoban-1.9.12.tar.gz"
  sha256 "b9e8b0d2f793fecbc26803d673de11d8cdc88af9d286a6d49b7523f8b4fa20e1"

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"

    bin.mkpath
    man6.mkpath

    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/cgoban", "--version"
  end
end
