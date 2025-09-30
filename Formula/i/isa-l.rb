class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "e1d5573a4019738243b568ab1e1422e6ab7557c5cae33cc8686944d327ad6bb4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "13a416bf4580a54a36d6345ffae8fbe9539e14d34f75f44367cf730682daeb40"
    sha256 cellar: :any,                 arm64_sequoia: "6715b874f4070412fd9fde672ac8d3afeabcedd94e585a2ee16a5e20823a3dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "cdde71e94bd415fff6acacfe9d8dcd064b956d639192ffae847743e46cee219f"
    sha256 cellar: :any,                 arm64_ventura: "ee7744d14e7835a1473f1c411e14648b56d3aa1af4d699357c1275c555a689d0"
    sha256 cellar: :any,                 sonoma:        "5a50a8e10d340dad15b350e8cfee247d36d305293aadb78802dfed9a9662f436"
    sha256 cellar: :any,                 ventura:       "02e1310ed918a703cc9d85e0cc6d4e17eee42fa64c640b82eecb68cfa837ee44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721ad28e5067ae0ded3a409859243bcbea8fa14b7bafc858424c177b4d6134e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6cc323c0888ad23cc884dbcd260f08706daf6ac31d765554adce4bd35fa3824"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  on_sequoia :or_newer do
    # Backport commit to cleanly apply last patch. This fixes type mismatch warnings
    patch do
      url "https://github.com/intel/isa-l/commit/841f9e34adf81176e6359e27a0fead383ed47bd5.patch?full_index=1"
      sha256 "6cbc36cfc6a3972725d90750311fa69fe79f6090e6bd2f2c4c588a971ca3e01b"
    end

    # Backport commit to cleanly apply last patch. This optimizes CRC64 Rocksoft
    patch do
      url "https://github.com/intel/isa-l/commit/9a6c32cb057789c7609acadcf8eb8b8818fe324d.patch?full_index=1"
      sha256 "78aeb37495bb52b5afbee5d7c3b544c7292650fc0be6ab91a3ca6becafdc0939"
    end

    # Backport commit to fix build on Xcode 16.3+
    patch do
      url "https://github.com/intel/isa-l/commit/73c50447fca763943942299c2a2c0c05c39c1238.patch?full_index=1"
      sha256 "11eb1648b11fcdb03401530e012a8f4d0e7becf941fc049aa2aa2a6d4410cf3c"
    end
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ec/ec_simple_example.c", testpath
    inreplace "ec_simple_example.c", "erasure_code.h", "isa-l.h"
    system ENV.cc, "ec_simple_example.c", "-L#{lib}", "-lisal", "-o", "test"
    assert_match "Pass", shell_output("./test")
  end
end
