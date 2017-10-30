class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.10.tar.gz"
  sha256 "891674d4c605667ad5ce912913784ecffa3b31b67bcf76d81c3c555cf97e5294"

  bottle do
    sha256 "5d07140727b968410332eafd18c9900f66177b28a8a73db2b22dfeaff8dfc692" => :high_sierra
    sha256 "055ea04ddb949c85cdf87b6341cb8ec63d4d94307e82fecc49d97037d3e17cd4" => :sierra
    sha256 "fff91a47a08cb9c0e10c4f0e88f69aa36b4c720a99432c38e94163ec665a96b9" => :el_capitan
    sha256 "390019ee63e7cc436534f679191f2e0e8d63fd84180337b061a5db4a1cb1f68f" => :yosemite
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
