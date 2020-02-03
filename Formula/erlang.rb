class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.2.5.tar.gz"
  sha256 "a2359af240c7f629a4f9f19a9c0ba94e6ba024ed9fc4728c8ae55ea7c8c0e260"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "42199fe5c88267b17242b18a5ea3605f42d008e74cf02e32393b111de05decdf" => :catalina
    sha256 "b36cf768e4cf651dd236f649bc8761a0a4b645a853abf6b4b338c01f1a3847d5" => :mojave
    sha256 "204cff791b0f875411c18b3c132055277af3df638c5df0a6b4552a2539b9595c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.2.tar.gz"
    sha256 "aad7e3795a44091aa33a460e3fdc94efe8757639caeba0b5ba7d79bd91c972b3"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.2.tar.gz"
    sha256 "09d41810d79fafde293feb48ebb249940eca6f9f5733abb235e37d06b8f482e3"
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
