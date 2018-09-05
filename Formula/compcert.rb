class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.4.tar.gz"
  sha256 "7098136318ea1db90d9807a58fd27e90306e8022cb7d6e335ca2c13f3787ec89"

  bottle do
    cellar :any_skip_relocation
    sha256 "0253060570372efb386b38514d1df0377e0ed81f293ad7204d8c540d7e6ad02a" => :high_sierra
    sha256 "b3fa1029e71733d2181a47198a143dc85ce0bc470b864b86dd9f47746e3284db" => :sierra
    sha256 "93636c31e770c928d59079a5e7dc8845ad226452b7a35852d80d942fc30dd9e7" => :el_capitan
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
