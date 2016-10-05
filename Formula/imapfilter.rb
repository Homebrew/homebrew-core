class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.7.tar.gz"
  sha256 "183efd43c805abaf3f60a1bca788d42da7f05c52fc952efd4555fa40233b4868"

  bottle do
    sha256 "b76be4fb923b75e836d78d58cd05c8edbf173f162fae03fd140611b6f32dfbda" => :sierra
    sha256 "473bc4d3ac25674e2c8ef0d64d7dda0e007e49a883cbd51b83c202e7a140bf6b" => :el_capitan
    sha256 "8ef9f93aa2ea8aadc9f2b72319f2bfc1670236ef95ca671b223b97836b7a5a67" => :yosemite
    sha256 "23c2c40f697d3b9f5f2c022a86f22af69f9b82ef71e6974c22763d0a04f18683" => :mavericks
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
