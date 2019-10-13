class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.13.tar.gz"
  sha256 "8ad94b94ddd47bd051ec875a3ba347bf3427f98ca4b63d60f38ea3a704c8afb2"

  bottle do
    sha256 "a9b232e3c3f1fc8f587bb99d9981f0c06459faf764008c6c980a3506c2ddf9aa" => :mojave
    sha256 "a4347057ac73e30d5348d27b23d115adc012487f20f4787caf985b318d86132d" => :high_sierra
    sha256 "11327b353bb64c94d61fed899b391f85424fa0f9ed42c4e44230c7e20afaff7a" => :sierra
  end

  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", "#{s.get_make_var "CFLAGS"} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
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
