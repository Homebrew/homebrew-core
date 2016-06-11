class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.6.tar.gz"
  sha256 "3ee921d9ca23c794291fa9815028e02c19e0549e1f8ded1133a0ee1747a6230e"

  bottle do
    sha256 "da881ec300ce9aac41f5ef968093df4bf9c1b170417063f4252ef7ea3c997c4f" => :el_capitan
    sha256 "005069beba02c916ba92d0f2a2beb20bf8d5f40cc922ce4ed46cf29a0c4c656b" => :yosemite
    sha256 "1bb76b2d13f56eb9c60ae2b870be74e86c4398c260939f7d23875afed042a6ed" => :mavericks
  end

  depends_on "lua"
  depends_on "pcre"
  depends_on "openssl"

  def install
    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", "#{s.get_make_var "CFLAGS"} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-liconv"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats; <<-EOS.undent
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
