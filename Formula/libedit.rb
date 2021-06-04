class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20210522-3.1.tar.gz"
  version "20210522-3.1"
  sha256 "0220bc2047e927c0c1984ef5f7b4eb2a9469a5b7bf12ba573ca3b23ca02bbb6f"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6a4159ed273ba498e091391dd5e84908be57294a8accc14ea88d17439e283df5"
    sha256 cellar: :any, big_sur:       "f3a3b11ac4be1ece253f272d3a1b596571e430041ccf813280417764b62f5264"
    sha256 cellar: :any, catalina:      "24bbdac27e417b37afbcbbee7c93ffed7e6fdfc27d32c8201e2bcb13fa129fff"
    sha256 cellar: :any, mojave:        "b229a23679ba4228e241bb957d5db3ca6ab139b7997e793961ab60cca8850e6d"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    on_linux do
      # Conflicts with readline.
      mv man3/"history.3", man3/"history_libedit.3"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
