class Npiet < Formula
  desc "Interpreter for the esoteric, picture-based Piet programming language"
  homepage "https://www.bertnase.de/npiet"
  url "https://www.bertnase.de/npiet/npiet-1.3e.tar.gz"
  sha256 "e819c766d12e1dfaf71561429486ed85b6ae4438da6e7ee06871ab5ce58231c5"

  depends_on "gd"
  depends_on "libpng"
  depends_on "homebrew/versions/giflib5"

  def install
    # A patch has been sent via email to the upstream maintainer.
    inreplace "npiet-foogol.c", "<malloc.h>", "<malloc/malloc.h>"
    inreplace "npiet-foogol.y", "<malloc.h>", "<malloc/malloc.h>"

    system "./configure", "--prefix=#{prefix}"
    # --mandir doesn't work here, despite --help claiming it does.
    inreplace "Makefile", "man/man1", "share/man/man1"

    system "make"
    system "make", "install"

    doc.install "foo" # not a placeholder
    doc.install "examples"

    examples = doc/"examples"
    rm [examples/"Makefile", examples/"runtest.sh"]
  end

  test do
    output = shell_output("#{bin}/npiet 2>&1", 255)
    assert_match /with GD.*?with GIF.*?with PNG/, output

    examples = doc/"examples"
    png_output = shell_output("#{bin}/npiet #{examples/"hi.png"}")
    ppm_output = shell_output("#{bin}/npiet #{examples/"hi.ppm"}")
    gif_output = shell_output("#{bin}/npiet #{examples/"loop.gif"}")

    assert_match "Hi\n", png_output
    assert_match "Hi\n", ppm_output
    assert_match "10\n9\n8\n7\n6\n5\n4\n3\n2\n1\n", gif_output
  end
end
