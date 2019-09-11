class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20190303.tgz"
  version "5.0.20190303"
  sha256 "adad7870988d44b95df57722ab8dffc587d035183eb6b12a9500ebed4d8dba25"

  bottle do
    cellar :any_skip_relocation
    sha256 "c786783f05f2aa98019d5142c7c8a019cf9caee471fa41aa7ba360d0b8cb6b6e" => :mojave
    sha256 "706723393e31a2969cb8686726426e72eaee75e848d60082c67da7daa1929ac5" => :high_sierra
    sha256 "fc9f42aad5f855408583a604ab54f8241c85464f5a7e44492452904aab55dfb4" => :sierra
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
