class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.8.1.tar.gz"
  sha256 "758a0f78aff30935916426c878d2cc803bdcd31c74982fbfcd2372e6744262cc"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "fa42431b27201f34c48a432672aaa7623d70d9ec0109920f259c8947f323ad4f"
    sha256 arm64_ventura:  "64b3069385debad96436af076e3c0b3b4b384f72ae2857fe655a70e76a62e2c7"
    sha256 arm64_monterey: "498a797ee4253b7ce1ec28943ba1bda7c08718a47d4022b2a716893d244a085c"
    sha256 arm64_big_sur:  "ca473c2082b24a28c5df4897ad3e8648fca6c34ad1a93df4c1fbaf1451a5c8aa"
    sha256 sonoma:         "182953baf05885cf7a23f44832129bdbe11d59b02ceca489e63882d2c8acc896"
    sha256 ventura:        "4891cc2a7dedcc5af85443f8ad5c8f682ad67be160f1478a3608d14f525fa9a2"
    sha256 monterey:       "be3575dd0ea2b5ad569091320df335aa09f4399d16b32dd5c7a5c3883af62197"
    sha256 big_sur:        "0bef10ef81f39901590756f70281c9d30ca62b339d658b91553baa0c4715e6a0"
    sha256 x86_64_linux:   "142fab3add0eca23d155c7f315d256c2e28be12e1613916d7a3d1e2970ec78b7"
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
