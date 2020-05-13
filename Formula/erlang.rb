class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-23.0.tar.gz"
  sha256 "a12263e031374130f5bd4ff01c13f2d39ced241c695267498b19c66012e03d6a"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "93e89a1fa2c80357a11a14b1000410cdd23dbeafc1413ec9aa33922d4ccb0262" => :catalina
    sha256 "d47037feb5074106545b7c20ab6c5d8a99a8597040114d01e072e5b41268cc71" => :mojave
    sha256 "5903ccca95c65b17219ded2fb1570f1332259b037fcd77add8ae1390b499b458" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_23.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_23.0.tar.gz"
    sha256 "c0804cb5bead8780de24cf9ba656efefd9307a457e0541cc513109523731bf6f"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_23.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_23.0.tar.gz"
    sha256 "4da19f0de96d1c516d91c621a5ddf20837303cc25695b944e263e3ea46dd31da"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
