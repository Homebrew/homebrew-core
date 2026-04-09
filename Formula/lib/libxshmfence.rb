class Libxshmfence < Formula
  desc "X.Org: Shared memory 'SyncFence' synchronization primitive"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxshmfence-1.3.3.tar.xz"
  sha256 "d4a4df096aba96fea02c029ee3a44e11a47eb7f7213c1a729be83e85ec3fde10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2db54053a9c58d5b8e5fdea2f705a4c877fe73dc26dcae6ad1171fbecf8dbb3"
    sha256 cellar: :any,                 arm64_sequoia: "e594a6ecbb103e2afcd62ce9093d3b7c42cd606af7ba3a82cd9a4c539e4d2d52"
    sha256 cellar: :any,                 arm64_sonoma:  "2458905e037ad4f18eeba6b04eb8501c30079e77821b9d71158ca7e966b7ce3d"
    sha256 cellar: :any,                 arm64_ventura: "b1ce7b250aec924e67c460575448f347782cdcfb9d2fd18f4c04ad5d994e46f7"
    sha256 cellar: :any,                 sonoma:        "b48d848198caab47d17a71cd910556d018ff81ea8f3f2d48b5165faec9da8e2c"
    sha256 cellar: :any,                 ventura:       "704aa281d7881a37f4c95f351a3a558898f5d153830edb3d03b16b6d13e42d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a90e1f18cc19078d0e7ad95b023deb2ffad6cd1b064e3fc86bc480553b5177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db4447d0738071d8c69faf8cafc59b4178b79b732324e0412d15733dc6cb323"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => [:build, :test]

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/xshmfence.h"

      int main(int argc, char* argv[]) {
        struct xshmfence *fence;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
