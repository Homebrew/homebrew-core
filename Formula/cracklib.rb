class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-2.9.7.tar.bz2"
  sha256 "fe82098509e4d60377b998662facf058dc405864a8947956718857dbb4bc35e6"

  bottle do
    rebuild 1
    sha256 "a21962259717ab187dc477310b0e68b28449135839312f7c632f0e46414efcf1" => :mojave
    sha256 "52c1e0acde52e27553ca3884dba490596ebc4a45019181bbb355ed9bad50e778" => :high_sierra
    sha256 "e2cfe716fb290d4dd26558290707596146e15ca8da510b38897c128f961779b6" => :sierra
    sha256 "12665f56731ad7a8c56143d5f263b99e7a8484cbb0e2f22b955978f63e724138" => :el_capitan
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
