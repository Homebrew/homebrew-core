class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.16.tar.gz"
  sha256 "90af9bc9875e03fb5a09a3233287b74dd817867cb18ec9ff52fead615755563e"

  bottle do
    sha256 "31d373cda17459d8a2fbaf05389e5411d09f27a5d692d2d838a3b2b1b31be7ae" => :catalina
    sha256 "f7096e093702f8bf2ec4cd7193177b659522f60024fcb68e1bf6329a3b2118c6" => :mojave
    sha256 "0c32e10f9e57e8080573ed140c4bada1bbcc562025ccd17e551a40d18ebf6175" => :high_sierra
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
