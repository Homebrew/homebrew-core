class Libxkbfile < Formula
  desc "X.Org: XKB file handling routines"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxkbfile-1.1.0.tar.bz2"
  sha256 "758dbdaa20add2db4902df0b1b7c936564b7376c02a0acd1f2a331bd334b38c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22592ddf483ed0ec9ccf361ca77513fda5a19954cc4e5e52c3079bbff07d4ad5"
    sha256 cellar: :any,                 arm64_big_sur:  "5d9fb616a049f24910c9f71e3f70cbb3920df9adadfb146cdbd550ad0ac508ca"
    sha256 cellar: :any,                 monterey:       "e31419789815b526116f7ace2e9063ad49401731bba80b8f6c0aa2867d7cf52e"
    sha256 cellar: :any,                 big_sur:        "ad23cdb5cd188e6581ccb16dd1b007a66448738f687a35523633432295f6524b"
    sha256 cellar: :any,                 catalina:       "18d3314727b519379948c4b69a242d0f52bfdba78cf2d2bc0f1cd1384510dda4"
    sha256 cellar: :any,                 mojave:         "19c4c1ad6066ba36e079e5b7b66ed2e66d6202dc9fbda01fd8ff6cf802264c5b"
    sha256 cellar: :any,                 high_sierra:    "94703acd3591d5ccec71ac964adce8b86ad370498add6026b9ba9dea0bc04d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0a9a6f4d9583aecb25f5e635be3a87665738350dfeceae207eeabe9b72a82e"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"

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
      #include <stdio.h>
      #include <X11/XKBlib.h>
      #include "X11/extensions/XKBfile.h"

      int main(int argc, char* argv[]) {
        XkbFileInfo info;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
