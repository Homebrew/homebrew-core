class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "a28ee90ac20a996e2fc19cbc36a36c152483085011f3b2ec8dfd913b7a6d9804"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "e936161f2b81aadf392a28ce2c0fac7e1df84542ba5e820369078d2520b00398"
    sha256 arm64_sequoia: "70c757de93288ef4e4367aa3fe55cd42f764a5ce18750bc71dddf21049ea2f42"
    sha256 arm64_sonoma:  "ca4b34e7d186953097c449ba67f55596aca8e8f4a69afb60c6d5314f3dc7d433"
    sha256 arm64_ventura: "f15d485165819dd296961c167070e2e516dc728859e4b163bc339f9000f5215c"
    sha256 sonoma:        "ea24e234a4966f529e93c36bc66c664b725bf616a5a2b286d87410d28ef6ebe8"
    sha256 ventura:       "1325382fbd71289a23633f2c51b7da08308b933635fd4168aa624397cbea66e1"
    sha256 arm64_linux:   "cef5702c2ca63d9a2a2d0b6ce8637bc8d9be9f9203a5465a42dc83294d2e0da0"
    sha256 x86_64_linux:  "fe050a935bffa0600d9a50adaed8f253886d32bbb18e8350b6596e5e3b83b8b3"
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
