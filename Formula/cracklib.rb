class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-2.9.7.tar.bz2"
  sha256 "fe82098509e4d60377b998662facf058dc405864a8947956718857dbb4bc35e6"

  bottle do
    cellar :any
    sha256 "5ec5d327b820cae5b28440d88557669c83b6035adde41858c753a822df203bff" => :mojave
    sha256 "9e73ad02d623bc310e908ee1e4d29e44bfc6c0a0d83dbaf96486986361942262" => :high_sierra
    sha256 "2345643d79e6c5abdf7dffe54f2a04862cd396f948454b69270a511816274ea7" => :sierra
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match /password: it is based on a dictionary word/, pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
