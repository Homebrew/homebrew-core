class Libxaw3d < Formula
  desc "X.Org: 3D Athena widget set based on the Xt library"
  homepage "https://www.x.org"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.5.tar.gz"
  sha256 "1123d80c58f45616ef18502081eeec5e92f20c7e7dd82a24f9e2e4f3c0e86dc7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1da3249d130032a6b1e74e656b981e65c1f1454c0e4fcd1a5005371af5d5ea76"
    sha256 cellar: :any,                 arm64_monterey: "5f5ed1fc3a846fd3debce17e0fe28d83385ba9f5910137d22c37318b5021d1a7"
    sha256 cellar: :any,                 arm64_big_sur:  "08e254bef35a20cf08ffb942277b0795a24c8f4ca0a73217a943acdaec4d3169"
    sha256 cellar: :any,                 ventura:        "112d6fa3cfb439948c7a4e7575e6bfccf3d169a0d8b970c85e8108d180a2622e"
    sha256 cellar: :any,                 monterey:       "6f7f9edb56f71177289815a000e350d18141801e6917e9a22544f032b7a29517"
    sha256 cellar: :any,                 big_sur:        "ca5b661b63007f4ad1e437429e2b6908e1aa13d0b7ff9fdfd4b24b097e02221c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a525a07f6901b07b3e47c3c09aa4d36a1357c822a7fca4446ca4893bc813bc"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-gray-stipples
      --enable-arrow-scrollbars
      --enable-multiplane-bitmaps
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <X11/Xaw3d/Label.h>
      int main() { printf("%d", sizeof(LabelWidget)); }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    output = shell_output("./test").chomp
    assert_match "8", output
  end
end
