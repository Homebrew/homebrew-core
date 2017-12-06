class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.11.tar.gz"
  sha256 "baea9596ed251910b176a2bdcd46d78ab68f6aa4e066f70ca0d6153e32df54fb"
  revision 1

  bottle do
    sha256 "02803ddbca53c23b2d5cb2a5a8f35ae793345d76edc1950425237fcf988e2b96" => :high_sierra
    sha256 "93dc1b7812665fe71b765e12febee6e82d73508e28f151221e25f127af916e2a" => :sierra
    sha256 "b167861900fb3f72c9852c2db920a96eb10aeb3b96f075b6f25e90ad99b03ddd" => :el_capitan
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

  def caveats; <<~EOS
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
