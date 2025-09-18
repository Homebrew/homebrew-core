class Omake < Formula
  desc "Build system designed for scalability, portability, and concision"
  homepage "http://projects.camlcity.org/projects/omake.html"
  url "https://github.com/ocaml-omake/omake/archive/refs/tags/omake-0.10.7.tar.gz"
  sha256 "ec098107429a419965feab5cee5dfa2996fc3fdc23842d910c314590941cafb8"
  license "GPL-2.0-only"
  head "https://github.com/ocaml-omake/omake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:omake[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4de04e995e24ff3f5ce9b25a34dbf77464d3722ae1fc0e0d6a4e37e308ea7815"
    sha256 arm64_sequoia: "81f480345c0653b1788f41971c2d374f1198203e1fa5e382aa68614a3855e7e4"
    sha256 arm64_sonoma:  "cbab9c88f4d900ccf872ce469f0eac0bf002e8fb78f47697177d59a0f5d96965"
    sha256 arm64_ventura: "e1fd58352aac92f14588d5867a39240934affcb79040b869c6fb7beb1c0a5f6f"
    sha256 sonoma:        "f7b331439ec53664c6475b856a53f33c51f09c6065d029101315b2e3c8f37ca4"
    sha256 ventura:       "630d8d9aab4e7ff5bcc4eb2619b68c314e355d8353e9780a4b429827e4d1642b"
    sha256 arm64_linux:   "e147fab15c1388ed0a7ba8c067663417a2e779dba1c4747a130ecd3989a4bf7b"
    sha256 x86_64_linux:  "8663b8c6c736ad807b39f45681cd3295ed9cdf1ff8ed58a3301da2e16eefd68b"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "ocaml-findlib" => :test

  conflicts_with "oil", because: "both install 'osh' binaries"
  conflicts_with "oils-for-unix", because: "both install 'osh' binaries"
  conflicts_with "etsh", because: "both install 'osh' binaries"

  def install
    system "./configure", "-prefix", prefix
    system "make"
    system "make", "install"

    share.install prefix/"man"
  end

  test do
    # example run adapted from the documentation's "quickstart guide"
    system bin/"omake", "--install"
    (testpath/"hello_code.c").write <<~C
      #include <stdio.h>

      int main(int argc, char **argv)
      {
          printf("Hello, world!\\n");
          return 0;
      }
    C
    rm testpath/"OMakefile"
    (testpath/"OMakefile").write <<~EOF
      CC = #{ENV.cc}
      CFLAGS += #{ENV.cflags}
      CProgram(hello, hello_code)
      .DEFAULT: hello$(EXE)
    EOF
    system bin/"omake", "hello"
    assert_equal "Hello, world!\n", shell_output(testpath/"hello")
  end
end
