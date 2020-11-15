class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.17.tar.gz"
  sha256 "a38f0f194555d558533b8b15c0c478e946310022d0ec7b34334e19e4574dcedc"
  license "MIT"
  head "https://github.com/lsalzman/enet.git"

  bottle do
    cellar :any
    sha256 "9480897cb890a7aad73fd5c0acacd948df787b382f8fd9145a7a15c3083176ed" => :catalina
    sha256 "a5fef5bb0564e20031ef2cd04e9348e7c1a734be0e7dc7ee897ed067ff861f22" => :mojave
    sha256 "53bf2d44d4966917b0526e13343bc11b08bfdbfb7bbff8698df58a0d4e4e64b4" => :high_sierra
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
