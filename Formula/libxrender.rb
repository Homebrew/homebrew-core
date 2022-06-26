class Libxrender < Formula
  desc "X.Org: Library for the Render Extension to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrender-0.9.10.tar.bz2"
  sha256 "c06d5979f86e64cabbde57c223938db0b939dff49fdb5a793a1d3d0396650949"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc2e9e34f51fbc1b9a0650084d6aa43d60b4c285d2b21cfcbdf9ae77be4472fb"
    sha256 cellar: :any,                 arm64_big_sur:  "46243f05a17674c00950dddc105b33aa479af7d605533d1aeada27d4d89d4275"
    sha256 cellar: :any,                 monterey:       "6b5d5e53d3f001a196b0e8ee0df7db0190885d1fb9e45dd0e57f9d7353f1a783"
    sha256 cellar: :any,                 big_sur:        "65fbad7a9da818086574a40880db58c8f2457db77aee1982d141cd09dad7e3a9"
    sha256 cellar: :any,                 catalina:       "cb7f48876d362f919ed1c34ece8ec5abb16f6e414a6119655e3948fffab5dfab"
    sha256 cellar: :any,                 mojave:         "77563596957d673a9f4acb0cb4f1e1d28c3b99e7f4a13f0a1dd1e3e403c454b9"
    sha256 cellar: :any,                 high_sierra:    "b1bf08a6c6c6827af5a3472ac979c9328b780da52c1d234d385ef1fc3b0771b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b4f9c57a6af40dda0ca45ddecb325f9de9bee28959ed11fc0fa52d2accf562"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
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
      #include "X11/extensions/Xrender.h"

      int main(int argc, char* argv[]) {
        XRenderColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
