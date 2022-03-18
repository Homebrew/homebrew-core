class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.7.5.tar.gz"
  sha256 "ab19f840712e6951e51c29e44c43b3b2fa42e93693f98f8969cc763a4fad56bf"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "c1b533dde74bd8ad2cb391dc22661a8706e61eae9fa96e402c5cae6d6aee6c2d"
    sha256 arm64_big_sur:  "e49fed469e38c13b29df94f07ce45bb40bdcf167961ba08e7199192346ce8cd7"
    sha256 monterey:       "c7ce821d215d9a32ea42f6a9d0857a0d1cf477a8a0d5d0552e25359f8e64a450"
    sha256 big_sur:        "a3f6c7500a3206466979cb184c75e5d06f2a478c04ba7de9a671e0ae4e578a65"
    sha256 catalina:       "4033f3f9c51c811a9bce55523d337f5d61ab987c742a90c02c12f97c00b768cb"
    sha256 mojave:         "aa77cdfd4279e290c68fe6aa1af6d40d820e10f3f53513d17c4867fcfcade11e"
  end

  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats
    <<~EOS
      You will need to create a ~/.imapfilter/config.lua file.
      Samples can be found in:
        #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
