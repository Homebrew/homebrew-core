class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage "http://www.xmailserver.org/libpcl.html"
  url "http://www.xmailserver.org/pcl-1.12.tar.gz"
  sha256 "e7b30546765011575d54ae6b44f9d52f138f5809221270c815d2478273319e1a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pcl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 sonoma:       "c2f937aca27092e775dc6c4262a318129560b1e079de3f077a307756ec31a417"
    sha256 cellar: :any,                 ventura:      "7318b096881fc158179da00e979a134736447b31f3c7f1047a78befeb129790c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64a2d65ad2bcbbdcc93eedb2771d85da04a69e1e3b3304c256c68d509bc0de20"
  end

  on_macos do
    depends_on arch: :x86_64
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
