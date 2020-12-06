class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.7.5.tar.gz"
  sha256 "ab19f840712e6951e51c29e44c43b3b2fa42e93693f98f8969cc763a4fad56bf"
  license "MIT"

  bottle do
    sha256 "ff90e2681be192d3b97c87e644eb0f01712f91630ac5125e5681ae6bc2eedc01" => :big_sur
    sha256 "0f686e00927ae8b38ff85c46d34974753387631fc7cbf2294d969f45e7c47e0e" => :catalina
    sha256 "dc6586a02c6b329096e02c01ebc5d191ac7ed74c4c856d199935750605a4ed3b" => :mojave
  end

  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv"
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
