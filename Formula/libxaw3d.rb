class Libxaw3d < Formula
  desc "X.Org: 3D Athena widget set based on the Xt library"
  homepage "https://www.x.org"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.4.tar.gz"
  sha256 "09fecfdab9d7d5953567883e2074eb231bc7a122a06e5055f9c119090f1f76a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd35bc13d40af71e5d343a0389c317b49e63ebf349ed6b539b4a5e5ce3e9ad9f"
    sha256 cellar: :any,                 arm64_monterey: "c27632e71c51d1e02478695a3cf86a33e1495962be23d89c6d26337ef0139884"
    sha256 cellar: :any,                 arm64_big_sur:  "79af9b3b321e268b4433fddcc2b1d1da5914bd3d5aba03c207ba2d598d42018f"
    sha256 cellar: :any,                 ventura:        "a161fc7a9dff6c43a6a58eea5b6990df803aa7803286d4958ac52a1c0b2c40b9"
    sha256 cellar: :any,                 monterey:       "89cd3f70c15b1dcbb054c9489b7e290a616b5846d55fd21c85344eb1d63ed6b5"
    sha256 cellar: :any,                 big_sur:        "135322539b609862efc73f0da4fc205ce554f7cc2e66c123fb4e043a738968aa"
    sha256 cellar: :any,                 catalina:       "1a0ea4ec35a674744dd8e0fe1c16b6be5998752845a152edf2f7e56da208eeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef88521dc9a085da28737de639fa4e652a03dfb1f93f30a76c98f5358f9bf587"
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
