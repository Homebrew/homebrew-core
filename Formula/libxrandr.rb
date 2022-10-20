class Libxrandr < Formula
  desc "X.Org: X Resize, Rotate and Reflection extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrandr-1.5.2.tar.bz2"
  sha256 "8aea0ebe403d62330bb741ed595b53741acf45033d3bda1792f1d4cc3daee023"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18ea888945e931d168308aac190c22bb0ad6a39322d6fc17068d9dcdba2e0f34"
    sha256 cellar: :any,                 arm64_big_sur:  "57638149377d964bb0452e1bdf36b9712ebe35254ed05e06ac2ff66fdbf6beb6"
    sha256 cellar: :any,                 monterey:       "6ead71682d570ad0bb9d6a0169f34b6c37ad53c13ba52218d11da7451b1cd02b"
    sha256 cellar: :any,                 big_sur:        "68c082bb3a5a94cd881edf9d575cb27ca116836dfdd6d46e69a1b18344b5df5a"
    sha256 cellar: :any,                 catalina:       "62f9efb3fcb658182731de45c6b8a20a941ecb5b1e14e4a5375aa3d1b58ef530"
    sha256 cellar: :any,                 mojave:         "d1cf6d028abfae84918dbfc05a497ee46daa653a2337a3112ecb101193f0ed2b"
    sha256 cellar: :any,                 high_sierra:    "5cd68c19e9821dff52249e3598b82c2010ddc43cb029fa80ef73c3b620c65bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb9fe7c6e55b0f95bcb5448e956dbb761e3ec330f945c4cb0d48dee0089ece9"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrender"
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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrandr.h"

      int main(int argc, char* argv[]) {
        XRRScreenSize size;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
