class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  url "http://libcello.org/static/libCello-2.1.0.tar.gz"
  sha256 "49acf6525ac6808c49f2125ecdc101626801cffe87da16736afb80684b172b28"
  head "https://github.com/orangeduck/libCello.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6549514d4a4273b05395f7a6cf6c23ad18f5071236fb89aa51fad03766fa646e" => :high_sierra
    sha256 "834e9f4144abadb68fca552b795ff1366870e4e141fde759b721dff600038483" => :sierra
    sha256 "54cfca99a424590796858d57fd1226c763abdf519715b7f7435b812ab504eed6" => :el_capitan
    sha256 "58f80b859bc0d3f40f4de5f1bf39168dd5560a98471c999f76d0416cca5a29fb" => :yosemite
    sha256 "28188bd3d10965c1a9e57d4ca3c652642ddb931a5bf0967fd6141b4dc12e2fc6" => :mavericks
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "Cello.h"

      int main(int argc, char** argv) {
        var i0 = $(Int, 5);
        var i1 = $(Int, 3);
        var items = new(Array, Int, i0, i1);
        foreach (item in items) {
          print("Object %$ is of type %$\\n", item, type_of(item));
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lCello", "-o", "test"
    system "./test"
  end
end
