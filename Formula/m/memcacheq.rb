class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://code.google.com/archive/p/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76a6335c95617676d29dc17b89faa4871f1b48308bab35117fe3d59def21c621"
    sha256 cellar: :any,                 arm64_monterey: "a9be9de387a93adf837f45192ce234676c7d4199b39fa0ff4c21ea025c9e1956"
    sha256 cellar: :any,                 arm64_big_sur:  "4bb8a364aa6925ca5fcb284820ac82fe0f895012315af6fa04778d8386cd3baa"
    sha256 cellar: :any,                 ventura:        "ef734a22aee16914c5d7bfb969c536ad3b502a0d2dce6e26af6982d4f3d455d5"
    sha256 cellar: :any,                 monterey:       "83abbc744c310b7afed5a767db77e20b3be0a1289cc5474d018a8cfb0dc368de"
    sha256 cellar: :any,                 big_sur:        "0fcdae22ade43e314bd26fe48a6a43a97592ccce1445336d83f90d9204a4daad"
    sha256 cellar: :any,                 catalina:       "10cc27ffb5112ca2570fcfc372993048a10b2a22a69f499424f7739219e45d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00507c2726969f342d96813393cc9fafe2073edd4075eb473ea8a86fa47129bf"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
