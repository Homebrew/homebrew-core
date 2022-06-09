class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e9c4ebb63fe37dcf77638f280e619776d4e93884d9063084432f18bff2020cfe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "376306719dba4e9f6e160df2f937349abf250a5d27ad8c7a1204bbd1a6ca4ca9"
    sha256 cellar: :any,                 arm64_big_sur:  "14b9982526582411bbd4b80575b6b743a51adafffad54096d4f6c5fcea95912b"
    sha256 cellar: :any,                 monterey:       "cc329cfe3a5133f50b9690bd20c6e4de867199635916672ee87782c7468446a1"
    sha256 cellar: :any,                 big_sur:        "6eb4c141e49222a95c004dc6ef4fe59ef98012524298f667ef9f672ef8ab4765"
    sha256 cellar: :any,                 catalina:       "dfc203b37c7969dd2ad7a70f5238d8db06d208acc9a0a9b999f1c39e677ed3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14031a634a9d9959a45396ba6140fcda33b944ac48ea1afb4a61b9b8977206f"
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
