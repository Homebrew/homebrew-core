class Libxaw3d < Formula
  desc "X.Org: 3D Athena widget set based on the Xt library"
  homepage "https://www.x.org"
  url "https://www.x.org/archive/individual/lib/libXaw3d-1.6.3.tar.bz2"
  sha256 "2dba993f04429ec3d7e99341e91bf46be265cc482df25963058c15f1901ec544"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c1f32a02317e87c23d9e029ba9a747e3cf8e4fb8fad73650bdb5385f6da7df3"
    sha256 cellar: :any,                 arm64_big_sur:  "7119d857a0d3c8b77967422b134fa028a6adcc136dc76a29e78997405ecc0b1c"
    sha256 cellar: :any,                 monterey:       "65a2e31d9bf407befc1151abc1f12eb6d1e15c4d6dff29b3729e19b27cfe5a74"
    sha256 cellar: :any,                 big_sur:        "4a5d334d3ed17d4fe8654edc1cc8e0168a282792e5a9e9c5e82b4d1ff1c260ba"
    sha256 cellar: :any,                 catalina:       "e089705cc442b4076b7d3b9bc86a1379eb193b73cb57387d04809411876eb755"
    sha256 cellar: :any,                 mojave:         "b5510c021114d1579116242eb88f4fbd6a9fd3d3a61292a17d6158c02ac71194"
    sha256 cellar: :any,                 high_sierra:    "ccf2fd19db504f82ab9f280525a879bd0669934a51cdc69003238d0626735b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6596ac50fcdcdcafdb4e3cc616826bd3b48ebb05b4bccd84c1ca10db64df6160"
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
