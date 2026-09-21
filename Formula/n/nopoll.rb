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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a28e9e44fdb915f72599a5a4325b58c1bf2603ff2892333c48bf7ab486a43218"
    sha256 cellar: :any, arm64_tahoe:       "f12009f63116bf0ce0e3ddfe4dc6024902b03f9b49b4e15805d3909c88bb8c09"
    sha256 cellar: :any, arm64_sequoia:     "2dc5037a4374c03cbfd126965368102ce346c3cf8d723c50f634453d3edcfa0a"
    sha256 cellar: :any, arm64_sonoma:      "50d5f7eac1524e1221f6973dfcbd9b28ccd00b80cb1ee9f3ffc42fe5e1139401"
    sha256 cellar: :any, arm64_linux:       "93dba60bafcb4726fab15cc1fd4e005cf638df8debfc0efe38399b0563656a94"
    sha256 cellar: :any, x86_64_linux:      "bd4cb5546b853b9b9b800f83089c29dbbe3eb28fbfa60c0e4469f9dc43f3cef7"
  end

  depends_on "openssl@4"

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
