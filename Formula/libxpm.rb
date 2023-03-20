class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.15.tar.gz"
  sha256 "2a9bd419e31270593e59e744136ee2375ae817322447928d2abb6225560776f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96f9a9b3a26de512ff75f44900cd19c53d279793b5bb5f32818ec29b7d2444f6"
    sha256 cellar: :any,                 arm64_monterey: "7f2b41403d7c41afa2687b8fbd1691a2161f830aad3814e7af88b7ab5b09254f"
    sha256 cellar: :any,                 arm64_big_sur:  "78da48b65e691f64da628051b6a2b705439d3ff9d59f8bd8115f5ebd9ab13258"
    sha256 cellar: :any,                 ventura:        "e64fe1b8af7fabfe6477a8a868ea3bb5c073412c31c4cdc8dcf9114fae511d59"
    sha256 cellar: :any,                 monterey:       "d026c450367aa00a79d1eed754ed481d7acabc751e22d9a4728b8f90ba10494c"
    sha256 cellar: :any,                 big_sur:        "c7f7c47e522b76dd4101c9be2309143fead96f431a64ec15eb490fb667d13d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb74411ca5a795dc26f2e5e765bbbe33f909b796bf70b46d9391ade66cfb714"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
