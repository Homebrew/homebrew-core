class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://www.greenwoodsoftware.com/less/less-551.tar.gz"
  sha256 "ff165275859381a63f19135a8f1f6c5a194d53ec3187f94121ecd8ef0795fe3d"

  bottle do
    cellar :any
    sha256 "e9c850a28846a39541fd76e5159071527e8db94258a809da968cf69e42277d48" => :catalina
    sha256 "f005662a0d661c28540163078807f4b518a6e6a2e8c86a5a0a0993eb6c4c4ad5" => :mojave
    sha256 "f9896f9b0e0fb82dcbafd312a93d05061a2aa6f451592b30ca833dbdfb2b38c0" => :high_sierra
    sha256 "a123eef24eeb7839ed0b7a3b0d53d17402c72576554fecaad81743e550b49107" => :sierra
  end

  depends_on "pcre"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
