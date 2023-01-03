class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  stable do
    url "https://github.com/anrieff/libcpuid/archive/v0.6.2.tar.gz"
    sha256 "3e7f2fc243a6a68d6c909b701cfa0db6422ec33fccf91ea5ab7beda3eb798672"

    # Fix build for macOS
    # Remove in the next release
    patch do
      url "https://github.com/anrieff/libcpuid/commit/3b0a1f7e5b10efb978cea4c5cb5b727ba1ef3655.patch?full_index=1"
      sha256 "d4dcc843e78fe5872aba483b0fb5adb0b8e702f6343a383db566dae81eec0d9d"
    end
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "b197362eee621d3118a68c1a5bd461beba3517c47fe014e1a94667e184f69557"
    sha256 cellar: :any,                 monterey:     "a0f4c5f49d9d96a02878b347591a648970f5b62c7913a14db6053cbc2ced9cf1"
    sha256 cellar: :any,                 big_sur:      "8ca0c97e736fb44cbb04e78fc8b952ee3d6fcad4bd4439aaad58ec0c1c3506ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "563a8283a606ee0f6c7e8cc48a1da9c8c444393055a68ce596b2c2b1dc1cc0f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
