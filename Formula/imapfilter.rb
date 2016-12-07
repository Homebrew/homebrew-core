class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.9.tar.gz"
  sha256 "6079c0244bf3bd29903b43315c72bd73c7c764b64cc99369bbd9b85618215341"

  bottle do
    sha256 "2a4716c913d90c0fabe0bf91f762f785c00c106855e050163c320ace3c51b52e" => :sierra
    sha256 "76b93973e164d52d577ec3df79370ab2ad9bb27929f4ea8665aea7c2eb8a2b66" => :el_capitan
    sha256 "0b33040e44013e2d39620bc4dbe0fea3ea9b817d398950d1f488ff87e49c50ca" => :yosemite
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
