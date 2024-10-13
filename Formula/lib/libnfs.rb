class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-5.0.3.tar.gz"
  sha256 "d945cb4f4c8f82ee1f3640893a168810f794a28e1010bb007ec5add345e9df3e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e758339be8153e070291e70acb20491ef97d2f1c56a2778e11f356ffcefc60ff"
    sha256 cellar: :any,                 arm64_sonoma:   "7a52ed77480250f7f6503c89b55939851022fda4b557723df98ee14572900003"
    sha256 cellar: :any,                 arm64_ventura:  "dff7c08f835774d855710f8195b3fa53d38b4a0d89a1277f8e422d2de6117e21"
    sha256 cellar: :any,                 arm64_monterey: "06f16c29ed988b38d91ee5f800b93116b41288f993a694603f0af3584f59fdb9"
    sha256 cellar: :any,                 sonoma:         "165309bcf7d58c4bbe4c62889d8de976b85e01102e1e49eb4a7d84632b35ef13"
    sha256 cellar: :any,                 ventura:        "00999f67b246396751e8fd9137cb057bf14b2b99f0d059fdaf6e2cb0fa25998f"
    sha256 cellar: :any,                 monterey:       "1df9d2c2a44214573663eff072d237b090d297ceadca7ab2923daca3cabc6a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da4022b87ad4d500dafafeccbf35e4bebcf2bbbcf23bb47a37c0b35edec09ec5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #if defined(__linux__)
      # include <sys/time.h>
      #endif
      #include <stddef.h>
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end
