class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.18.tar.gz"
  sha256 "74eb57253ed3085686371a331737daf072223b77f76bba13ed65a4b3aa6cb403"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfb4812d9570c75c744777378f7653ec3e0072cc64c1676652aba5a63ffb93be"
    sha256 cellar: :any,                 arm64_sequoia: "d08be880b43305b277322925741f7f138c5905a36424a70f2c07d3f8a3327f92"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c7ad30c0f8032516bd5fb60ffa9901a2d93a46d91431cd4e8843b93d661f0a"
    sha256 cellar: :any,                 sonoma:        "7fd1c8870bcb2cd60c92ec28220a3815540cf2c36330fa457843e1f10ad55da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba51d06c36169b8cc001fd6f284eb7a0787b1b59f621f68ff1913647ecb3a56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448c52d170a337416e588bc7d6b36d267de2ad1de1efe939a6b11bc48aa8fedd"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
