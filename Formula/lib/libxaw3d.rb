class Libxaw3d < Formula
  desc "X.Org: 3D Athena widget set based on the Xt library"
  homepage "https://www.x.org"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.6.tar.gz"
  sha256 "0cdb8f51c390b0f9f5bec74454e53b15b6b815bc280f6b7c969400c9ef595803"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ffc7352d5468f1da6202bd9c1566a8c1cf49b44152b544a2ce62818c2eeeed2"
    sha256 cellar: :any,                 arm64_ventura:  "8f6971e4a904d41772fba2491d01ee9e21fba496b40f84bee8a168c59bdce5e3"
    sha256 cellar: :any,                 arm64_monterey: "f25553783d983bf33fe4203a8dacbab78cbfd231966a02aeaa855860d6deda58"
    sha256 cellar: :any,                 sonoma:         "b0eef1591b585288f82ce3017b8ce36e5c6793c0e3b0627eba2509a0960d92c2"
    sha256 cellar: :any,                 ventura:        "b27e3c30367a1a17006739a1f1f3eff77cdbdd9754d9359fb8d46f8005df0abd"
    sha256 cellar: :any,                 monterey:       "5f21c207d01e94f48635d107491699a4c7e28abb96bf9de5b3224550c33af19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a9400728bbced335a4f415dcce6613737bbb6e26328493873ebaa986c83d52"
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
