class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  sha256 "0103081ffc27838a2e50479153ca105e873d3d65d8a9593282e9c94c7e6afb76"
  license "GPL-3.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libassuan/"
    regex(/href=.*?libassuan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a59bb546c313037d25fe0ce8fe7143e5a454cabe06faefff43a863e57202f1c2"
    sha256 cellar: :any,                 arm64_ventura:  "91b13a3d01c3794e89698212891d1dca01f6e2407973cf0a13c4f64570a01f7c"
    sha256 cellar: :any,                 arm64_monterey: "2ab1dc78890cc7a79356f599819cada2742bfb8641632b1cf2ca36c205ba4d7a"
    sha256 cellar: :any,                 sonoma:         "374ca8d1d6b08a3f68c21feaad028e2fffdb0b903ee63c8fd976af5eba38cf19"
    sha256 cellar: :any,                 ventura:        "0fff1a32a910475de0f30cb0dc9540d38f6c2935f00fe5cf41939c7ab7a3020b"
    sha256 cellar: :any,                 monterey:       "44cdba98921aa0e5bb14c80b89bcfd20947f9d6afd811d8393e6f86925c1fe77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1e7b9102cd33e6b2b88741834d711182ea0a222e9bec775aaa68ece906a769"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
