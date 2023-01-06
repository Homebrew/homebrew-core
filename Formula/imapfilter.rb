class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.8.0.tar.gz"
  sha256 "8f75ad334ce31e0bb1cd3aaed79c17ed4667673dce69d43cdde9087e801c0b81"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "768f378b2b679e0a26c99a4402a0cd39f6fb7dfbd1e644d417dae83d0cf51351"
    sha256 arm64_monterey: "be36c8bcf1e5077761a963a80adbfe360a3090cdb99d073dd663d74df79cd6c5"
    sha256 arm64_big_sur:  "62d9824157d64977da4fade83fd71b752825b7cadadce847cd93a2266ee22d61"
    sha256 ventura:        "9562bbbc0020e6e927d90d8132d52289e3d83f9c51e9e3e7c5f248aa30406e28"
    sha256 monterey:       "cd9a9a84255d108443bb6b32dde91aca01a51b27763664b77de595ca66345cec"
    sha256 big_sur:        "3829da19784bd85c8a219b697ab71a3c547375580c819ed26b3700d2bf800199"
    sha256 catalina:       "9b8300f60e29f5eca3d454fcc0b4b3897f7d4f246d498f14c06daada5ea535e2"
    sha256 x86_64_linux:   "4f2cd0900d481f7fcac24b90128b4cb9edaf89e7c0fe2ded6af3f13533bb1a51"
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
