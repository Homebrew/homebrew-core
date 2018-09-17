class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.4.tar.gz"
  sha256 "7098136318ea1db90d9807a58fd27e90306e8022cb7d6e335ca2c13f3787ec89"

  bottle do
    cellar :any_skip_relocation
    sha256 "67ecedda2c906df96558f64d918fb4b1eacf82f51931d090db17c4533eeb8bc0" => :mojave
    sha256 "037513cdd7b75ba60e9ab3fb2e78201e7bb3eb36bc02aa8493377e7e8ada3e58" => :high_sierra
    sha256 "54a044c3b9f387eb400c2a7e881a2b2df040d02786fbd37da8948db2a362ae9a" => :sierra
    sha256 "6d33c7c5f3e1fb223a164392b1cdaa7c548d8bf8f44f0c0a7472bc4683a8a4de" => :el_capitan
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
