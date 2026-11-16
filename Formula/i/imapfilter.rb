class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.7.tar.gz"
  sha256 "fad8eb3779f2b40ba10b1ebaeee57044cac14139a6a59b37d27aeb598f19799d"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "c60a44fe2bb9323021d989362838b9531bad99bc0f2e6ba27ba8b2742c2c49dd"
    sha256 arm64_tahoe:       "aabab7b3556edd28da6c2ef4b41adc3af610f4ec3bbb1b8d831911808b95706c"
    sha256 arm64_sequoia:     "8b662deb79c5012abdce4d40cb1f9d060b877677b577663d45c1fbc44a6f2ade"
    sha256 arm64_linux:       "2cd6718364baad524b3a28436bba19c66f5c890e10996f86f5466bed1f7513dc"
    sha256 x86_64_linux:      "33fe8fb653788e5c05a7f1253e83b12847394a8eb5ac9cf94ac32d5392a264c8"
  end

  depends_on "lua"
  depends_on "openssl@4"
  depends_on "pcre2"

  deny_network_access!

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("lua")}/lua"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("pcre2")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("lua")}"
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
