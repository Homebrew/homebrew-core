class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.6.tar.gz"
  sha256 "7a77839f6b990ab632ba14feccf4f17da189f0e3b95d6ce2ef0986e4caebc575"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94adf65e12d17e8d0f51c3fcc1366b60c921eed5440db95fb7265523f6cb724" => :mojave
    sha256 "ca910a58b799eddcbde7e6533a41467acbdffcb907b8ab8b0746bda1475e1070" => :high_sierra
    sha256 "40a2d27ae39a8dba01750b97990fee506296cb1a5f45acc3bfaaa2dd3b3baeda" => :sierra
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
