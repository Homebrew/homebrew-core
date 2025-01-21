class Libsm < Formula
  desc "X.Org: X Session Management Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libSM-1.2.5.tar.xz"
  sha256 "2af9e12da5ef670dc3a7bce1895c9c0f1bfb0cb9e64e8db40fcc33f883bd20bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0b0ac49d0bf49d72f1157a8216bd0579dba8568f5728f5c78a5ba275d3db13e"
    sha256 cellar: :any,                 arm64_sonoma:  "4a91715675a2a4d983d3b6c0aa0ed12d797d085dee35e6daaeb60c64c81a45a2"
    sha256 cellar: :any,                 arm64_ventura: "82f2a4a29270dbf1835f3ed1fb1082b1cb452f43dfb64398aa6590c31211aa9c"
    sha256 cellar: :any,                 sonoma:        "e5a6c0098e9d7692ada5af93ead6c5fe8f436a40c0aefd48a9872d1e05526f52"
    sha256 cellar: :any,                 ventura:       "7f40ed534f1a72d79e4da7e246a43cc5c4f8c1b86e96632cd972b0701f7b6f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe133929dc73f2b9f23eaa8422a6083c623d14a9d07dba603605d0c02b0e2f6"
  end

  depends_on "pkgconf" => :build
  depends_on "xtrans" => :build
  depends_on "libice"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/SM/SMlib.h"

      int main(int argc, char* argv[]) {
        SmProp prop;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
