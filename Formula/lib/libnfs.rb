class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-8.0.1.tar.gz"
  sha256 "03653086471ceddd846077151adc6fda9ebc47118010a196e27f4f2e3e5e32f0"
  license "LGPL-2.1-or-later"
  compatibility_version 5

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7ed920fe89be50c7f868c3e737076a5ae4ebe090452c9655fb7e9a1358ccc08f"
    sha256 cellar: :any, arm64_tahoe:       "f3b65659daa3fd594bf3cbc8180acfc83089b6fd48ea998d6912890a0d0c31aa"
    sha256 cellar: :any, arm64_sequoia:     "afa41c038854b4fde86c0ec862d538fab2025407685575d4b6b9c8c26d91fe2d"
    sha256 cellar: :any, arm64_linux:       "50aaeb5068e5ab07f237d98d57596d634261f9c4a909fbe93f719ba6db577e78"
    sha256 cellar: :any, x86_64_linux:      "17b7be29913a1bc3c43d1b1686ac0280f2a8d69310658722c78234e6853189b0"
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
