class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.9.b462.tar.gz"
  version "0.4.9.b462"
  sha256 "80bfa3e0228e88e290dd23eb94d9bb1f4d726fb117c11cfb048cbdd1d71d379a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aspl.es/nopoll/downloads/"
    regex(/href=.*?nopoll[._-]v?(\d+(?:\.\d+)+(?:\.b\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1be50a5fd9560140bf58dbe71539acf5a300b2623d150302fbf64b5eb811701"
    sha256 cellar: :any,                 arm64_sequoia: "c3e56788b97b459d0c22ab331bc493bcdd0351d50e52b8691bd83ea77f7e59e4"
    sha256 cellar: :any,                 arm64_sonoma:  "4a269b4003f8ea4330e1deaf825e7eb3f09bce0fde98d0877ad07f4fad0cd20e"
    sha256 cellar: :any,                 arm64_ventura: "3e06f4dfc41ee91d605dbf475fc05e21949926bee077814db7a112675064bc90"
    sha256 cellar: :any,                 sonoma:        "e975ca89eb4c551a44f51e0a18a32f284f37378a0c4b12241aa0453b2379d712"
    sha256 cellar: :any,                 ventura:       "6bb22066512d52292136ca4639e83d7b8598d0b076fb8b722ee80c3b0e7ce3a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d3b4783e75e686b85236223815cfce6d9afce02319002ecd56fae81c4146b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233ad48b7c725a46695aa3b60261610281ffd81cb010f58fd089b2bd0c4fbbd1"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nopoll.h>
      int main(void) {
        noPollCtx *ctx = nopoll_ctx_new();
        nopoll_ctx_unref(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/nopoll", "-L#{lib}", "-lnopoll",
           "-o", "test"
    system "./test"
  end
end
