class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftp.gnu.org/gnu/less/less-530.tar.gz"
  mirror "https://ftpmirror.gnu.org/less/less-530.tar.gz"
  sha256 "503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2"
  revision 1

  bottle do
    cellar :any
    sha256 "f005662a0d661c28540163078807f4b518a6e6a2e8c86a5a0a0993eb6c4c4ad5" => :mojave
    sha256 "f9896f9b0e0fb82dcbafd312a93d05061a2aa6f451592b30ca833dbdfb2b38c0" => :high_sierra
    sha256 "a123eef24eeb7839ed0b7a3b0d53d17402c72576554fecaad81743e550b49107" => :sierra
  end

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
