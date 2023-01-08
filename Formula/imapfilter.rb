class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.8.1.tar.gz"
  sha256 "758a0f78aff30935916426c878d2cc803bdcd31c74982fbfcd2372e6744262cc"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "67b75e7d0b6b166d03dd0053346e93b1ff9dd200c591d857ec99c77141165e44"
    sha256 arm64_monterey: "c218dd29692c68a06abf4279da69f6c008e2faa5a5810ace6de037cd9d735548"
    sha256 arm64_big_sur:  "ec8d74b1b656a6638b5e75ce14b1c67f3e4fa6286e69c2b60dc11651a7d69a18"
    sha256 ventura:        "d820c4695ce7693851db4213563049f7c0a830f054a0df9e035e119501f1485a"
    sha256 monterey:       "f86755a29d1e7fe00ab1cf3db6036de2fbb897c36b5b7369bff47914bef0f93f"
    sha256 big_sur:        "12e06cebb920f5c875782ad23eea982e7c86bac07be14ace7d49e37290aa9b21"
    sha256 x86_64_linux:   "808d8c167de5c92a88dfba386cd7e6a595b249ec237aea691fb96676d4a3178e"
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
    system "#{bin}/imapfilter", "-V"
  end
end
