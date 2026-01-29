class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.7.tar.gz"
  sha256 "6564608dc3b816b0cfddf0c7ddc62bc579055dd70b2f28113a618df2acb64189"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cf2c8903d82f28e0e854c8d6d3dff46ea98c5512724e5349af40f1edca88e9c"
    sha256 cellar: :any,                 arm64_sequoia: "71225436c92940977248a28433951e8e26732d3a9eed954ce1999a770f93f98e"
    sha256 cellar: :any,                 arm64_sonoma:  "b923d628018a401db1737f1d76eaf815f58f0a9e73a86a0de13b164760bb1921"
    sha256 cellar: :any,                 sonoma:        "2674d35eb9596b8d9b6149519e39bf6e43d4959894109fbc22f48f9d5ed85a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6150f6cdb2ee2195ebf90f1e6a95f4a27d2ee4e1e3c17959807b7c8eb3075d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc771ee68f57189ea941e83f2f5ff18ac94878ae35c30aed8868a906834d148"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
