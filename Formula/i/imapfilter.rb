class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "cfdf84598dcccc8a54597448f7cdc7efc450282e23a865ddf59819ec99ac944d"
  license "MIT"

  bottle do
    sha256 arm64_sequoia:  "a86a7ded52a8e71bbc47227e350be23c75048abf12b600de513992d47036621c"
    sha256 arm64_sonoma:   "7d6c919f69f27c26027cb795c1e3aea7918c5331ad83c046e32fe25ad2f33705"
    sha256 arm64_ventura:  "0be43a3b47befd632437296ce2fcad1aeed742fe9fddbcb846c20ac10514c0b8"
    sha256 arm64_monterey: "18e5ff2520d2473cb31d88bb02d368dd195e85de6255906d31813c4b987d2787"
    sha256 sonoma:         "42bbf189c63df02748ecc5011819ad974825676f7e8d3af406b465bf39a531c0"
    sha256 ventura:        "50076c18ae2c45315735253753ff8c60f230166ee43ca9303d134eb714633735"
    sha256 monterey:       "f043fe9f082b19bb066517346af9c09d46bbfbebffc6432be93c7a9773cb3c6c"
    sha256 x86_64_linux:   "63bc0a6f3f7ef561296bcf1d148c4d56341eca968419f528aa1889a78f984725"
  end

  depends_on "lua"
  depends_on "openssl@3"
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
    system bin/"imapfilter", "-V"
  end
end
