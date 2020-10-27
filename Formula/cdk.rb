class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20200228.tgz"
  version "5.0.20200228"
  sha256 "b23b55e2f21b4f1a2d6275e0ee017f4acfd5654f9c318080193ea71b7727b3cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6af3de91a67f7bec4481770831733635e80467dde908806b7f236c4a367fec1" => :catalina
    sha256 "d14ec66c67dd3cfeea5679661a1c6341ac1efa6d5090bbe72def80529051d9b4" => :mojave
    sha256 "c3576b57b44eba4148477a0e987197c9f7d766ba6652280aa915989dcee441ad" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
