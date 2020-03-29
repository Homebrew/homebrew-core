class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.6.tar.gz"
  sha256 "7a77839f6b990ab632ba14feccf4f17da189f0e3b95d6ce2ef0986e4caebc575"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c09396cc678b8a62fec2baac29a470d0dbbe4c1b32ab0cb4dcca494c5473b42" => :catalina
    sha256 "367a724e0c91c3e10ae23a0e8967b2e9138ac772f62d496aef9ea321ed33353d" => :mojave
    sha256 "b4f5ed998f34cd4d16537c580f8bf5ada8a95730ac0645bab208652c2a3057ce" => :high_sierra
  end

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  # coq 8.11 compatibility. Remove with the next release.
  patch do
    url "https://github.com/AbsInt/CompCert/commit/b7374d225af55ecc6f5d6aa8f3684bfae99ff465.patch?full_index=1"
    sha256 "a873dcbf7855935e4b5087883ef07b3fb0c17b6e62a1a0c266a009e0bbd3c794"
  end

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
