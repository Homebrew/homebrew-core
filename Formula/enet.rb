class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.16.tar.gz"
  sha256 "bbb77ebb607f4a03ecce0b06304bae4612bc26f418b75340644cff950562efd1"
  license "MIT"
  head "https://github.com/lsalzman/enet.git"

  bottle do
    cellar :any
    sha256 "7188260137953334ee61ed7eb2252d813e3cb7d86985d0d18ed3e1ce84bc965f" => :catalina
    sha256 "34bc8c1bbc9d71e2af3ec8f65dd24d681ad70be68f67534bba9a40f6e68bf21e" => :mojave
    sha256 "95634a66c99f7cb4f2b4a402017fee5f2ab1f6cb36f2fe75725c44c36908bf1b" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <enet/enet.h>
      #include <stdio.h>

      int main (int argc, char ** argv) 
      {
        if (enet_initialize () != 0)
        {
          fprintf (stderr, "An error occurred while initializing ENet.\\n");
          return EXIT_FAILURE;
        }
        atexit (enet_deinitialize);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lenet", "-o", "test"
    system testpath/"test"
  end
end
