class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.16.tar.gz"
  sha256 "90af9bc9875e03fb5a09a3233287b74dd817867cb18ec9ff52fead615755563e"

  bottle do
    sha256 "bc61c3bb6e5679d7b4f8b767e659c0cb3d4ff2f4fdd9e66a0ae38bc7df693965" => :catalina
    sha256 "5982d6a5404868c41dda6e3d2dedc2781ea45cebac19c8f58546d2f99865f492" => :mojave
    sha256 "651e44b6067c219ac07da7770c3aade81536ce36cb16b574c4a6d88d3498d6e2" => :high_sierra
  end

  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
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
