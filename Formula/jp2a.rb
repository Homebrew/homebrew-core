class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  # Do not change source from SourceForge to GitHub until this issue is resolved:
  # https://github.com/cslarsen/jp2a/issues/8
  # Currently, GitHub only has jp2a v1.0.7, which is broken as described above.
  # jp2a v1.0.6 is stable, but it is only available on SourceForge, not GitHub.
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "a9aa7c8893c63ad5621788af3813ed9758e09e0c79b9ba3a8262d5c17b2272f9" => :catalina
    sha256 "4e62b310889a384daf9058267ac0b1bdc73d2cb408f05b9e3d3072be52355bfd" => :mojave
    sha256 "8400fccf2a4459fe37ce0f3856459127f4f66ff002c356f36942462c0c9c3809" => :high_sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
