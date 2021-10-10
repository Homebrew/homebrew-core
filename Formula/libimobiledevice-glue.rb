class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://www.libimobiledevice.org/"
  license "LGPL-2.1-or-later"
  # Official Repo provides both a populated master and an empty main branch
  head "https://git.libimobiledevice.org/libimobiledevice-glue.git", branch: "master"

  # libimobiledevice-glue has no dedicated release version yet,
  # so currently a HEAD-only package to fix the other libimobiledevice HEAD builds

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
