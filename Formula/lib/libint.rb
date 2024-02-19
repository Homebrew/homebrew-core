class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "dcd528cea99c9cedfd147437048ab82d384f29e95850482d54049bbaf05c2271"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5319498a882ee5c17f1aea594ad3aae7ba8c647bbe5e59c289a811df82f8c6ce"
    sha256 cellar: :any,                 arm64_ventura:  "7c9df4d7cc07eb51b0c200a332ede398043e230cf365db4c2f5ce56555bc3484"
    sha256 cellar: :any,                 arm64_monterey: "5778abd9344ca0b88cb187c4221c1e5143ed0a7f7f620971c7635b74b504d837"
    sha256 cellar: :any,                 sonoma:         "3f9bd20b21892f77e0f825fbb3c0e9bc39a36b354851270753d11daf55da44d9"
    sha256 cellar: :any,                 ventura:        "1a2acc349728c4022602744dbd646c3ead1f4ccf298f57c7e44b02aa38242c41"
    sha256 cellar: :any,                 monterey:       "45953fdfe33b1959796197abf064d1b265d3f01fb04016ae36553eee696e8704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3efb031866412a42276d76dd5e593571265c10baa4f27b773792876b551593b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
