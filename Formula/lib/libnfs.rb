class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-8.1.0.tar.gz"
  sha256 "7a8c39bed7678b84ac0ab4607b64b5ce44e14c1bbe463cc072314ff4e75754ae"
  license "LGPL-2.1-or-later"
  compatibility_version 5

  bottle do
    manifest_sha256 "ba756dcd3db99fadb7814a2377019c73d371271f9e52c6dfc59c97f7611ac2dc"
    sha256 cellar: :any, arm64_golden_gate: "ce03871a2b1e7ca9003f64f8496a98f9fb9ef1e1703585ebfe51e22438a469f8"
    sha256 cellar: :any, arm64_tahoe:       "e4ec8be7b787f8882d5fa9875755decdcfdb6d05674f7be8dedb2ec8bade3d7e"
    sha256 cellar: :any, arm64_sequoia:     "658cfe5d9957efeab49b514e03cd22b325c10a3fbf81286e0d73f68e93760b9f"
    sha256 cellar: :any, arm64_linux:       "ef27403cd8a3ddb415598de0e8ba9761346e5d3cf3b1dc2f784ffa6992b5b3f0"
    sha256 cellar: :any, x86_64_linux:      "76a84ec4b3d5b8530f8f398ae5cb83762e9dca96c01c2d6e0a8389571187bc78"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build

  deny_network_access!

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
