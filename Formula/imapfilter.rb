class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.12.tar.gz"
  sha256 "764a68c737e555d7b164644a4c491fd66cffb93d6077d58f502b94e1a022a884"

  bottle do
    sha256 "5a50b18109dc9055b6a16d1cf0ac3e167b8c75660c02056f30a14a710a49bbea" => :mojave
    sha256 "02803ddbca53c23b2d5cb2a5a8f35ae793345d76edc1950425237fcf988e2b96" => :high_sierra
    sha256 "93dc1b7812665fe71b765e12febee6e82d73508e28f151221e25f127af916e2a" => :sierra
    sha256 "b167861900fb3f72c9852c2db920a96eb10aeb3b96f075b6f25e90ad99b03ddd" => :el_capitan
  end

  depends_on "lua"
  depends_on "openssl"
  depends_on "pcre"

  def install
    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", "#{s.get_make_var "CFLAGS"} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
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
