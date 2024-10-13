class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.11.tar.xz"
  sha256 "f3fa3282f5570c3f6bd620244438dbfbdd580fc80f02f549587a0f8ab329bbeb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "49cc37e73988074d48d1942e5d0d865a10a67692aa4752b5ac30c91a89ef4d79"
    sha256 cellar: :any,                 arm64_sonoma:   "5af5678065c243a7d199b76facc8be615dd6aa6de65d03778e9b403e8b2827d6"
    sha256 cellar: :any,                 arm64_ventura:  "d8cc440c5804ecf424d96d3cd4e92e88c83d43e7f927126c768caee2dffe36a8"
    sha256 cellar: :any,                 arm64_monterey: "8f7c0378757601370d13539c5f1a11f560326464d9ba1f9fb9f5e2631163d559"
    sha256 cellar: :any,                 arm64_big_sur:  "1bd9a72f005e6d7e746a95baf003b561756076623a074d7ea9d6fd0207d15eff"
    sha256 cellar: :any,                 sonoma:         "10a5ba27ae98aad4e5f236a550a483a36a9ff13d3c3de388056fcfcf0b743614"
    sha256 cellar: :any,                 ventura:        "7da43230a047e78a346707b6673d9f8a4077af03f1676121df279f7f5f1dc6c2"
    sha256 cellar: :any,                 monterey:       "3b8790c3aaf98e0ce10fd088f66b2591e6b5fb8b6b95df8ec254f389e15f81cf"
    sha256 cellar: :any,                 big_sur:        "306524aec65e6ea22e5d18fbf5b09f1a544fce2a9bc37349b3bc5d98a14d7984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba968fc488e6fa7d6d1f734ff79b85f0b4ed2ffa8dd7d19b0e61e48ec7f2cd44"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
