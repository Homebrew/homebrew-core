class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.6.tar.gz"
  sha256 "7a77839f6b990ab632ba14feccf4f17da189f0e3b95d6ce2ef0986e4caebc575"

  bottle do
    cellar :any_skip_relocation
    sha256 "e904948cfca89178fa8c3c30c915297dac6e7c2e6d0b6e92c73751840dc7d93e" => :mojave
    sha256 "bf146ab08494dbc6980eb6ec1974293c429bfad58e7bc1dcd1d9ee38bfb2d40c" => :high_sierra
    sha256 "cec12dd570caf6a5ac749a73adb88e5dd2d3a0ab354e586857a00a0d1ee2aaa3" => :sierra
  end

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  def install
    # We pass -ignore-coq-version, otherwise every new version of coq
    # breaks the strict version check.
    system "./configure", "-prefix", prefix, "x86_64-macosx",
                          "-ignore-coq-version"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
