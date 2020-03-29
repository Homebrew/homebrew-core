class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://www.greenwoodsoftware.com/less/less-551.tar.gz"
  sha256 "ff165275859381a63f19135a8f1f6c5a194d53ec3187f94121ecd8ef0795fe3d"

  bottle do
    cellar :any
    sha256 "a76b3f1fb43e1e0ab566a70eca5430afa744d6d87430b55e9a5b98160834c8b9" => :catalina
    sha256 "2ee3f16d15855ab88ad87067085c0f2dd58c90c5b91ae51499ae0548a24693b2" => :mojave
    sha256 "46cd5ba33b6a1d00cfa3993712ea617bce5b6c9908b016a72413f370eda714be" => :high_sierra
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
