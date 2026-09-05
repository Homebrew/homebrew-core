class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-7.0.2.tar.gz"
  sha256 "c5adfcbcb4554b673625d2b6de07c3d787ca4185179d3e130d33453e67e100aa"
  license "LGPL-2.1-or-later"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0fce96881163a186518162e96e7023514a1e9000bc75e54292270296eb6126dc"
    sha256 cellar: :any, arm64_sequoia: "fee9ca4fa5fdafaa7ffb979fa4250612449d24772cff84f6ef34b95e5cadc43a"
    sha256 cellar: :any, arm64_sonoma:  "c42f5db155f1878ae94aaede1fa5a158a38724226b75c936e91ca73c677b0575"
    sha256 cellar: :any, arm64_linux:   "49f0493854e6ae3edd5866ba744e8dd73f89e7447675e0038627aa7734dcc21a"
    sha256 cellar: :any, x86_64_linux:  "357d2921e88f4db420bcf7cc1c42bcc40d054f2c14439e8aa6b61d21e4cf4ffe"
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
