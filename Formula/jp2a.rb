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
  revision 2
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d16ee154fb63f13083414c8777ca2bbf69bb130411e6907522acf214c60dc81"
    sha256 cellar: :any,                 arm64_monterey: "9da454ebb89a11e1074e54975b9bae9f93c4bc38a53025a48c2f7e78c2d59765"
    sha256 cellar: :any,                 arm64_big_sur:  "81e6bcf5a143c3867f9f883e7e5c5a5c7c38743a646ce6f5fac36eb54ec95c02"
    sha256 cellar: :any,                 ventura:        "4ee4083e5efa260c57bddf85defec763b59f10b15e0b6c8aa7aaa98a0efb6216"
    sha256 cellar: :any,                 monterey:       "0088d29ea1ec66a0f5ce9f9249b2922fe32d1c3e8c37f32656a444ddae004aa5"
    sha256 cellar: :any,                 big_sur:        "1e24bbf2f7aa650f995992f6b8ae80938873dfc396ecd23341984188c285c6f9"
    sha256 cellar: :any,                 catalina:       "438f6b2d10513c8960f67db6e688599ef42282287ae64d8e366815bd4f545e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd434fbaabfb9b2f5d10a1cb47b95cc1838c2d91e5e0a25b4fd8ae592055782"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
