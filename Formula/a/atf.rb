class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://github.com/freebsd/atf/releases/download/atf-0.23/atf-0.23.tar.gz"
  sha256 "a64e2427d021297f25b3f2e1798f8ec4dc3061ffb01a1cd3f66cc4cee486b10f"
  license "BSD-2-Clause"
  head "https://github.com/freebsd/atf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^atf[._-]?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "acbf43372e23b1ec798d9220e6035f76a8d42d61af90ab40c43b32dc90b22745"
    sha256 arm64_sequoia: "14d17d25d50313d4fbd2794874b972925f23c67dea567ae1ec692efd32c2647f"
    sha256 arm64_sonoma:  "b8f3e848fb9147744c021fae004abe9cb8ac262c94d6bcd4a487b79ea73e6cee"
    sha256 arm64_ventura: "b0e02364b9ab0b317420b1ed1045e9c701ad002653b9180832a18e29c5c542ec"
    sha256 sonoma:        "9cd739eb6f0f1ec5c7a7718c66fea9ea8a3435ffd3506da93d60393f0bda5f0d"
    sha256 ventura:       "f454fa5d1f845261d605e9d94a926b6cd4e3a120a6782fe0f93776ab01697df6"
    sha256 arm64_linux:   "5b259959f57b981567bc83a2889401ef8224bc504e46428a62569cb3eebb054a"
    sha256 x86_64_linux:  "9e2c5311676f2350c618ba8b2092a67df2fa2300c1212d1f25bd70f4650ea934"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    SHELL
    system "bash", "test.sh"
  end
end
