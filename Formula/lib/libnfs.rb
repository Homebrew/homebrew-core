class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-7.0.0.tar.gz"
  sha256 "d25c70537d60f1ab307b9cb5e9fb01acff71065fc9547b54dfaec109ba993003"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "246ceb7d310d50823a082eb81bbcff812d181f65a4a19073a896922ec931096a"
    sha256 cellar: :any, arm64_sequoia: "856f595a5f08c47b142d118d7acddee581228f72ced55dabb5e145ec5a1ddd0c"
    sha256 cellar: :any, arm64_sonoma:  "cd93f0cbb54a6089b5d1a424213bcd35b90b1be6ae3108d43188bbe1e31b0f52"
    sha256 cellar: :any, sonoma:        "992a6348ca9f3c7d96f6405cff8544c830452e68efdd8039953fcb75b98406ce"
    sha256 cellar: :any, arm64_linux:   "8aefdb702cf9d593f1aa42c4605d92e21ff1ea33133e4946575c834ddb9120a2"
    sha256 cellar: :any, x86_64_linux:  "228ed8878690d6eb3dc18876141007da180ba4be0848cba381dc3f83293e6a2e"
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
