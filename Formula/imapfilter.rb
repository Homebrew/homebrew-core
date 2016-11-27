class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.8.tar.gz"
  sha256 "004b21fe9fe9cf087680985552e29ff1a6bd1935c193ac7f6c4b21558cab9303"

  bottle do
    sha256 "0a2518958c1ea6df24ab3a4f7248118cb50d28e8d35d414586391c77bc18de7f" => :sierra
    sha256 "75a379e2fc7e1821235ed67da955d1ff0e2fc177359a75129aaf62161b6d307a" => :el_capitan
    sha256 "4c40f47fa1ca823396dcd833472f99f42b43d1f9438bb9f4037ff2c99fd9509f" => :yosemite
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
