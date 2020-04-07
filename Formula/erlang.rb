class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.3.1.tar.gz"
  sha256 "34677d4604b6357db03b6cf79226d9fc1bbdf0ecb5e7545f2fe7a834cec93a83"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "aeb18f87b3059b6256aba36957d3fb5c475f628c07aee49263003eccba4772f6" => :catalina
    sha256 "86d816fcf632c71da3575edb78ef51e2160d39044a42203a011b0d193fe1a290" => :mojave
    sha256 "5d10a00f5c377afd12975ad5c3e552fd1b94054bfa4168b137196488e4ab838a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

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
