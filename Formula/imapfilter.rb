class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.11.tar.gz"
  sha256 "baea9596ed251910b176a2bdcd46d78ab68f6aa4e066f70ca0d6153e32df54fb"
  revision 1

  bottle do
    sha256 "67f26b296a296dec1541d6d262769c4e7c6c693a2404e4cae453734737012b9d" => :high_sierra
    sha256 "def25b0787198b1446cc17aec5e6c9c4150541879bcb7300bc9c334a5ac8f87b" => :sierra
    sha256 "b5cdc69c5b7401920b21ddadee0f5f8b05969ce304b6859176a9f175e493b91c" => :el_capitan
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
