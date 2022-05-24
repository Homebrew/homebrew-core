class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  # Do not change source from SourceForge to GitHub until this issue is resolved:
  # https://github.com/cslarsen/jp2a/issues/8
  # Currently, GitHub only has jp2a v1.0.7, which is broken as described above.
  # jp2a v1.0.6 is stable, but it is only available on SourceForge, not GitHub.
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  license "GPL-2.0"
  revision 1
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2446f6228b6059e993b3ff60c738449cd11c21d1c3005c133b1ab19d1e85b2fb"
    sha256 cellar: :any,                 arm64_big_sur:  "d76bf96595bd8e388e19adfaa4fc9d635f497f597ff1a9f1ba2abb3f1c2f3dc1"
    sha256 cellar: :any,                 monterey:       "39c167e125eed22c08a1c1c8053e7023492ddb1af07b18c9d9aa634b07bbd324"
    sha256 cellar: :any,                 big_sur:        "8ab042d2d660fbc55e4a055e0618d85fbbd32029f703d35c59f3d12c0b000936"
    sha256 cellar: :any,                 catalina:       "a9aa7c8893c63ad5621788af3813ed9758e09e0c79b9ba3a8262d5c17b2272f9"
    sha256 cellar: :any,                 mojave:         "4e62b310889a384daf9058267ac0b1bdc73d2cb408f05b9e3d3072be52355bfd"
    sha256 cellar: :any,                 high_sierra:    "8400fccf2a4459fe37ce0f3856459127f4f66ff002c356f36942462c0c9c3809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ca49b6a1b7d58b2a65e998e0e4636c72a13f5e4af51704c36950ef89818356"
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
