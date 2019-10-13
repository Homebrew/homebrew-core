class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.13.tar.gz"
  sha256 "8ad94b94ddd47bd051ec875a3ba347bf3427f98ca4b63d60f38ea3a704c8afb2"

  bottle do
    sha256 "2b231497ecc9b21909b094b1efa4e17f1f79b6a2979ea93bf0a240d29c576b1e" => :catalina
    sha256 "852a4de7ce4b75fd8cabffa890398d3669d9db731aefceaeb78e44665999fedf" => :mojave
    sha256 "92ef62f52a3d8c61b9918f1b3e6f399b64754d5c2927026be4674f2336b12ce1" => :high_sierra
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
