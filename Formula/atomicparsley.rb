class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/wez/atomicparsley/get/0.9.6.tar.bz2"
  sha256 "e28d46728be86219e6ce48695ea637d831ca0170ca6bdac99810996a8291ee50"
  revision 1
  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "632b3bc281a6f3bd5b9a913dff1e805c9fb9997f41b4a02db0a1aa34f6faced3" => :catalina
    sha256 "d32a565f675bd0b2c5ebf1b5aee01fb79d9d42b072dedf724b7ee03b2cc242ee" => :mojave
    sha256 "05c4cdc1dfc14fa6f06fdbbcadead5055a9fb53091d014458b86ecb4b22111fe" => :high_sierra
    sha256 "d5f8672d420511ff76fd9ecc4d41c8aee5eecbf4382d7c4bd3fb04400c4617f4" => :sierra
    sha256 "c0a7964ced998b2db7150f95b9329e138f28f0768be50d531fd4d82754e0ebde" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  # Fix Xcode 9 pointer warnings
  # https://bitbucket.org/wez/atomicparsley/issues/52/xcode-9-build-failure
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ac8624c36e/atomicparsley/xcode9.patch"
      sha256 "15b87be1800760920ac696a93131cab1c0f35ce4c400697bb8b0648765767e5f"
    end
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
