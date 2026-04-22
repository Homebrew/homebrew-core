class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "81930d83c99a07305554b2fd283422aefb4f069e13cff971377f3f844e601424"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "1ffec7b7bf2c3c7f24bfc811025285e07faa6739701b6dfe1576c7713234935c"
    sha256 arm64_sequoia: "5b5390a704d72710b016e5c5917afa812c717328e6960939a353157f09088124"
    sha256 arm64_sonoma:  "651cffae52fb88e225283749dad1a275c423f2218127a318efb60c982421d4da"
    sha256 sonoma:        "edeb5b2c307b63a2dda4361dd61a52f59c29db146dd117c43d0566ec4c72328a"
    sha256 arm64_linux:   "2aa3b98279fd72f7024ad9815f171fa31111026926248b0a7a1ba0548984b6d5"
    sha256 x86_64_linux:  "80b95649f62f4f690f8f687bdfe2b14d0bc6e4d9ed4cd127415ae63ac48f43ed"
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
    system bin/"imapfilter", "-V"
  end
end
