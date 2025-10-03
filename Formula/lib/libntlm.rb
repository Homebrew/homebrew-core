class Libntlm < Formula
  desc "Implements Microsoft's NTLM authentication"
  homepage "https://gitlab.com/gsasl/libntlm/"
  url "https://download.savannah.nongnu.org/releases/libntlm/libntlm-1.8.tar.gz"
  sha256 "ce6569a47a21173ba69c990965f73eb82d9a093eb871f935ab64ee13df47fda1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libntlm/"
    regex(/href=.*?libntlm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "881bfa38e82c41ce3dde641b5b8127ca0e5d906cf4c7e5f6787a3ce3b465d9e1"
    sha256 cellar: :any,                 arm64_sequoia:  "bebdb2ee8c5ef33fc95cd079147d06234b5661f869b6a88d23d68d4abd6fb28f"
    sha256 cellar: :any,                 arm64_sonoma:   "2629d0038710546db1d05c77d273189bed4554ab7b6f7e67444a80b6fd52cb0d"
    sha256 cellar: :any,                 arm64_ventura:  "6a07ff33c447c44d0271951ff00810244d7e46fbdbbefa3697533d442e807f31"
    sha256 cellar: :any,                 arm64_monterey: "3cdeede8fb7af5aeaf2e29d7a2c1b8d77f49602830eb7cda1bd541bcc468d379"
    sha256 cellar: :any,                 sonoma:         "a7d7f2c53526d724adea9d98fbef0219052797daef5ef6d0e3f12ebe38a105e7"
    sha256 cellar: :any,                 ventura:        "d01d0c60d1f35088786efd8b5a4f943a6feaeb5f03f484e43dfa342aba675877"
    sha256 cellar: :any,                 monterey:       "9d1dad1589edba9d4490611fb7a8499e8d2ab0c89f23a81f1d3426aec0b755a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aef30b36aec73ef9fd25107d285a8400151815df28e9c361ccfce157d8e7bedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebc4d50ef8a904ec1c686c8e869a83d727c55fd490990fb5481d6a34b970ce1"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
    pkgshare.install "config.h", "test_ntlm.c", "test.txt", "lib/md4-stream.c", "lib/md4.c", "lib/md4.h"
    pkgshare.install "lib/byteswap.h" if OS.mac?
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cc, "test_ntlm.c", "md4-stream.c", "md4.c", "-I#{testpath}", "-L#{lib}", "-lntlm",
                   "-DNTLM_SRCDIR=\"#{testpath}\"", "-o", "test_ntlm"
    system "./test_ntlm"
  end
end
