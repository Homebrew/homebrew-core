class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "5d9d3d321d4c7302040389c43f966a70d180abb58d1d7df370f39e0d402d50d4"
  license "BSL-1.0"
  head "https://github.com/sionescu/libfixposix.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b0253b42d4aabdfeac674a45f3e55f4e98e7fb89af64200122a0cb01c8d94bad"
    sha256 cellar: :any,                 arm64_sequoia:  "23db0bbb66f78f226e8f1c3391e6f098be1410f1e914367ef4efbf2322870e16"
    sha256 cellar: :any,                 arm64_sonoma:   "17e8781690ca305f8a30593f08d99358d99b1e8963e713aeb18a2c06d8e0a7e9"
    sha256 cellar: :any,                 arm64_ventura:  "fa1e934fadfdcf752a4cadf5c48158c2c07640b513963bb7430f155a3f807205"
    sha256 cellar: :any,                 arm64_monterey: "c970ea63811367c2464438b9b67621a2b268e60a2b836bbddaeee987c2d09719"
    sha256 cellar: :any,                 arm64_big_sur:  "338f883d482e6a1b21a91de414fcdd8ba6960ccab9658123568845b2c5d05644"
    sha256 cellar: :any,                 sonoma:         "86e9405e5c780a7011555ea50b980d32fbb1721f0ba53a6acb890a1e292a004d"
    sha256 cellar: :any,                 ventura:        "ae6bf46d3e2ef00c82034f6e63068f58bf3f0d1717d245bc319ba38f3b16cb71"
    sha256 cellar: :any,                 monterey:       "1d7590797c0860a0d26dd646ce2b7e3fbd1c3a4822fc6a4fcd811abb42c8e0c8"
    sha256 cellar: :any,                 big_sur:        "e943656ff8b13e2b577be3098534a2a6d2c4de9494b1a93b34d303fd4c79a388"
    sha256 cellar: :any,                 catalina:       "e683efeabc1a25cea8a7d56701ed332d7bac33f608e9501e05f51a0e1cbf86ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c830b4e29003a72949cc73e2ff51ef21f8794799f0419dcde5aad13fccf311a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af87e982e579778df2e7e49331b81489445e30753fe9397f340dc95f293f43ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"mxstemp.c").write <<~C
      #include <stdio.h>

      #include <lfp.h>

      int main(void)
      {
          fd_set rset, wset, eset;

          lfp_fd_zero(&rset);
          lfp_fd_zero(&wset);
          lfp_fd_zero(&eset);

          for(unsigned i = 0; i < FD_SETSIZE; i++) {
              if(lfp_fd_isset(i, &rset)) {
                  printf("%d ", i);
              }
          }

          return 0;
      }
    C
    system ENV.cc, "mxstemp.c", lib/shared_library("libfixposix"), "-o", "mxstemp"
    system "./mxstemp"
  end
end
