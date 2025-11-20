class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.18.tar.gz"
  sha256 "2a8a0c5360d68bb4fcd11f2e4c47c69976e8d2c85b109dd7d60b1181a4f85d36"
  license "MIT"
  head "https://github.com/lsalzman/enet.git", branch: "master"

  livecheck do
    url "http://enet.bespin.org/Downloads.html"
    regex(/href=.*?enet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "174732c193f0fe91c3f9b91204153f8f17369666a87ec9f8ae7dfa52ef7c4f77"
    sha256 cellar: :any,                 arm64_sequoia:  "c1785264ccb278a9595c68354604b48a02d1e05f5c1d9ce1e8f2d3d6baa704d9"
    sha256 cellar: :any,                 arm64_sonoma:   "e078c1459c03714c7bfacf48e92c9245ac4d4842479826b4f76d9e49cca66e45"
    sha256 cellar: :any,                 arm64_ventura:  "8bcb6508f5e8ff25fe137e0f3373a3f005c3d26797881cbce22cef4056e76c1f"
    sha256 cellar: :any,                 arm64_monterey: "e2c4a31201788842f820b7f90745e90286b7675940d3edb65f545e3e021b057c"
    sha256 cellar: :any,                 sonoma:         "826941d0ca8527b5be6121478c8f713b3f72ca69413cf43ef655a616ca0e0551"
    sha256 cellar: :any,                 ventura:        "ef5837ce67084857ced1dcc5d467f644420a4eb0eac7cb846134274e1c58d0b5"
    sha256 cellar: :any,                 monterey:       "f6eb8f65dc979ec67b61ece60ffad7543b6c246b37400f48809c97a0d56ee987"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3508a6482efac67de8c2891deef55af7bfa8dca3599e8445e39bc9a795ab5d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f47239030ad6e2af53bb52c6a040f0bb46424ffd3909819c190e939a63a8a3"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lenet", "-o", "test"
    system testpath/"test"
  end
end
