class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  url "http://libcello.org/static/libCello-2.1.0.tar.gz"
  sha256 "49acf6525ac6808c49f2125ecdc101626801cffe87da16736afb80684b172b28"
  head "https://github.com/orangeduck/libCello.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7719b74c5507dfd84ec93c043c11a4113e13a66f06e9d6f32349ec83042ad2" => :high_sierra
    sha256 "561319859455b756f53013090f91d6b06b1093c00d59593519ec09210f6bf830" => :sierra
    sha256 "05384667bb4d98a603406b3bc35962651af06d44eb55f2080c80f8dd979a9d80" => :el_capitan
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
