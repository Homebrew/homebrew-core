class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.0.3.tar.gz"
  sha256 "b8594588992ef44b141a17f7fe621872d211ce3c083dabfcc65eb4585d3dab38"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "0bdda2b47fc7b4e92a012ae5a4ab7736505934f494cd307ca09fceb7f5b65a4d" => :mojave
    sha256 "64c7845774c18c597d85b8ebd760d1989b0a055bd124c807e5949bbc51a445ab" => :high_sierra
    sha256 "77a53a7454fd6f3dc0994c93dc8628da791bedebae86b3fd08f34162ff6e1edd" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.0.tar.gz"
    sha256 "c3acdb3c7c69eaceb8bcd5a69f8a19ba8320d403c176a3b560f9240b943ab370"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.0.tar.gz"
    sha256 "64da88a0045501264105b4cc8023821810d23058404a3aadb8da1bc8fb5c13cb"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
