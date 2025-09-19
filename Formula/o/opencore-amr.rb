class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz"
  sha256 "483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "38dea780c6b453fcae6c1addb3054b0d14a4c216183a319e26575f61fda8050b"
    sha256 cellar: :any,                 arm64_sequoia:  "48a7944b5baf1d23777ff16d0f1b44ba3fb1872728e578e245993019895b0075"
    sha256 cellar: :any,                 arm64_sonoma:   "b9598108fb81e647206266d1ebfd43872454df8d9eb8292e09b550fb190e5c4f"
    sha256 cellar: :any,                 arm64_ventura:  "673be457f0de7494de04b1d079de9074e79e03a74f1fe520227f75d7c7953265"
    sha256 cellar: :any,                 arm64_monterey: "9641b13b82cf4d325e2fc5a0b2576a9ffb6d8d3bead8c6637e4b22a35ed24776"
    sha256 cellar: :any,                 arm64_big_sur:  "6dea7b138a3e3399d4295b70cd1dd9311ecec98bf6eedb24617b91d2020404f4"
    sha256 cellar: :any,                 sonoma:         "9c8eb887fac92ec6077aff4031f73c6cf493c0e41f1f54e3850e356ee911309d"
    sha256 cellar: :any,                 ventura:        "b9aa683edb4806619271a8f462c455cf2982124660fb03219b5858c22d2eb721"
    sha256 cellar: :any,                 monterey:       "cc0a074376ddcb0b30ab94027b603f8228fa951e35fda58b7bd274ae2efb4206"
    sha256 cellar: :any,                 big_sur:        "f235307e30e1ff626c14009955d924826d86cf92518ea36707c5e63469d29a8c"
    sha256 cellar: :any,                 catalina:       "afe967f68360acc0d6c3aa40853170f228499bf6917d13257ab3b90a341d1968"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8119c11b0478615bb8b9942f67e333a8947abea04766d36c3b38deb175c90a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63626c6d52b176f1289a792a8dea8845104f85e86538054e88efadbf920a9835"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <opencore-amrwb/dec_if.h>
      int main(void) {
        void *s = D_IF_init();
        D_IF_exit(s);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopencore-amrwb", "-o", "test"
    system "./test"
  end
end
