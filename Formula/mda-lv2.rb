class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2.html"
  url "https://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"
  sha256 "cd66117024ae049cf3aca83f9e904a70277224e23a969f72a9c5d010a49857db"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b2af5a11588172d4f3a6df39aa6e364d5bf80308801d18df16c92599af6b9753"
    sha256 cellar: :any, arm64_big_sur:  "70a7e6c2ec6687191da96a243d428d3a36f39f2eafbbea149fd2518dc70001af"
    sha256 cellar: :any, monterey:       "fd1f1846a982e6a4dd7a9ba034061d9afcb568bbcb9b95bb768250f53fa5d669"
    sha256 cellar: :any, big_sur:        "11305c6dd1065f380811fc8fa2058d2885360eabc95592a926e583fe43c0d6a7"
    sha256 cellar: :any, catalina:       "479125c63a6736dbe110711d9978764f1b44bb2520aa9646c2ca2fb7aa914f4a"
    sha256 cellar: :any, mojave:         "d10c751b2b276f037f4ee8b4cbe00871fc390c47661957ba96713161b1f6411a"
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install", "--destdir=#{prefix}"
  end
end
