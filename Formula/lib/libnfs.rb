class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-8.0.0.tar.gz"
  sha256 "bc91216e927a85142b5de611c7f711558e02119a7daad67620ea631634038350"
  license "LGPL-2.1-or-later"
  compatibility_version 5

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c8750421a0d5a06dfa06c97f3a487486d0c121937c21dcfa3fa90037ba3e72e"
    sha256 cellar: :any, arm64_tahoe:       "dc2e5fdcb607e26d3182d252b3cdb22d7da204820d31c5dc0590c63b79362793"
    sha256 cellar: :any, arm64_sequoia:     "ed8ec08b9ff5fc20dde4b1684c016b65b5fe08c10bd38a7930f7d5b6dc9e7ab5"
    sha256 cellar: :any, arm64_linux:       "8641151933e154ac0d4c4b6fed91100ceedcd1151f77b33ecd7c49cf827c2cfb"
    sha256 cellar: :any, x86_64_linux:      "7803837601cc0de193f9669442d2a18539ee343fafd5bebeff9f9a488ddd98cb"
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
