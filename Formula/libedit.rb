class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20170329-3.1.tar.gz"
  version "20170329-3.1"
  sha256 "91f2d90fbd2a048ff6dad7131d9a39e690fd8a8fd982a353f1333dd4017dd4be"

  bottle do
    cellar :any
    sha256 "537d74532e5778f106e87e682169c7ebfc3acd6624286d3ded9e79262bafc4d4" => :high_sierra
    sha256 "1bac371537a7a38d1193bcbe80170b5a2d592f568c5d7f6f8e01fd2fada68a3f" => :sierra
    sha256 "3015b4190af4a5ddf26739884dde6ebb289cc16187958213d904551a51777013" => :el_capitan
    sha256 "45a9c2abf6fb9cd0c8cdcbad8a708e00879aef224b573069cc21cdb6e42e109b" => :yosemite
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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
