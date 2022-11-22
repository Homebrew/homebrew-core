class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.14.tar.gz"
  sha256 "18861cc64dfffc0e7fe317b0eeb935adf64858fd5d82004894c4906d909dabf8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f66c7c37f350124dadf52fd095e82968c2c1eea5578700f42363467c3d032345"
    sha256 cellar: :any,                 arm64_monterey: "b61cb17b276c4022b041f0cacf3574ebf7828eecec90c50ce2994238071bdcac"
    sha256 cellar: :any,                 arm64_big_sur:  "45de39851d4dccde446173f2df20e89a7588fd3b9029f3f8e6bf0e3976b05ed7"
    sha256 cellar: :any,                 ventura:        "181c8bcf5bd644149f4107a9fe00d1d1cea4b0eb6fd0ce7451ec9ed26a639a98"
    sha256 cellar: :any,                 monterey:       "1b4e170f0804f2223320b204b8dca5276af8b5d88b301c3cc696c8e2962d75f0"
    sha256 cellar: :any,                 big_sur:        "1c5c57e3d6ecc16842a5bc30e3fe13fcb79b6cd9226815d5f765165806532153"
    sha256 cellar: :any,                 catalina:       "a5a896ef27db136e4c02a033fe254aa888175410e60826b0693b4913852a30c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97bf7345dd7ef36d58d873c15a5845d1b7523b0730306ee4ed290e62958c49e8"
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
      --disable-silent-rules
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
