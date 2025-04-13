class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "e1d5573a4019738243b568ab1e1422e6ab7557c5cae33cc8686944d327ad6bb4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
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
