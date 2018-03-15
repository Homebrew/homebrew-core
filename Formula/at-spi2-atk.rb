class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.1.tar.xz"
  sha256 "b4f0c27b61dbffba7a5b5ba2ff88c8cee10ff8dac774fa5b79ce906853623b75"

  bottle do
    cellar :any
    sha256 "48c602408de01b77eda096193eee53a1454997d08fe3c85b3877f578e31703d1" => :high_sierra
    sha256 "6de46c9205787cfd5edb73940c1d3a8c4ebac9e5c17169d542c4899e04865e77" => :sierra
    sha256 "1183cac8649c61abf5729837ed2809a4420fa97195fc221ef380aab9df1984e9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
