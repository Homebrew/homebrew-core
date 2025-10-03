class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-6.0.2.tar.gz"
  sha256 "4e5459cc3e0242447879004e9ad28286d4d27daa42cbdcde423248fad911e747"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49434cf4624dd2870f29010e9732abf65b3fac22346ebdc1fab0fc6c76b89a59"
    sha256 cellar: :any,                 arm64_sequoia: "2e9065bfd3abd3ffe1d38f5637551210ee628b9512eedeb4d30ec5889c2cd346"
    sha256 cellar: :any,                 arm64_sonoma:  "146e3c3bff06a7f0235889cc38a392f4fa2a0371a03523f697a764b2c59ee770"
    sha256 cellar: :any,                 arm64_ventura: "d7e4428a240be4fd0c4fec619de6b93846305156b054b8e813917a2a70a17a26"
    sha256 cellar: :any,                 sonoma:        "4509c2de7ad0dc7583d3d4ad6f17719eaf306adf33dcc5e8b272a69c153aa276"
    sha256 cellar: :any,                 ventura:       "15287f2942eb74117211df3c6b6bdb9bda26755f4d725c6e355bde38e162e7ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e709afbb129aa4d910765a61d1c6ad522a793d864d2fc23b42300573a933cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0477428f6b57eb2ebc18e86a9c62951d42623dfb516b6f8e6b409625f943a233"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_DOCUMENTATION=ON", "-DENABLE_UTILS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No URL specified", shell_output("#{bin}/nfs-ls 2>&1", 1)

    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end
