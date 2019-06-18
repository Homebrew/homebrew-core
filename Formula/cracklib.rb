class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-2.9.7.tar.bz2"
  sha256 "fe82098509e4d60377b998662facf058dc405864a8947956718857dbb4bc35e6"
  revision 1

  bottle do
    cellar :any
    sha256 "cdf8e3240e77e574df95271024c7b260ef5eafea27dfa6f6188c1a686dd1b9be" => :mojave
    sha256 "210b950eee847fdccdb388c14d87eb425182282e581187302daa91dfa166fb78" => :high_sierra
    sha256 "3e74c66c810e5faa99833fc89d375945d0059ddc4b13b5f57128de70cff9dfef" => :sierra
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
