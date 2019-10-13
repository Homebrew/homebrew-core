class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.1.3.tar.gz"
  sha256 "53a828c1199a41cb54bd3bc6c2c49af977a8834e702c030a5ea34013a3fcacdd"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "418959e01fa739cce1217ec61c95d696c46ac19a24b25d599cc677ca2827f4ae" => :catalina
    sha256 "6c81685e5c6cde1da04c1ef8b879785f6fac0d99f0b19acfda60067be663fd3e" => :mojave
    sha256 "9be1896837770096af6388220e0780ee247f1a966dea91990dec920ea888f8c8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.1.tar.gz"
    sha256 "64f45909ed8332619055d424c32f8cc8987290a1ac4079269572fba6ef9c74d9"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.1.tar.gz"
    sha256 "3864ac1aa30084738d783d12c241c0a4943cf22a6d1d0f6c7bb9ba0a45ecb9eb"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
