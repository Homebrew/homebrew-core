class ErlangAT20 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-20.3.8.23.tar.gz"
  sha256 "0f7ea88ebc58b85f146ca6db7a53f14109becf693e7cdac15c03c59dc34af0cc"

  bottle do
    cellar :any
    sha256 "3b6c01716226369dd3501cf25c489ba9cf8a50f45e921cbcff12bf2bdfacb477" => :catalina
    sha256 "17588664535bc927ca750d992db576d1b720e7fb3f5f2145a1fbdc42c7bcca6b" => :mojave
    sha256 "69c18bae54cbd16a4a1b4e8077a5111d97643a355760ff3a5a4e37ec580a513f" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac"

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_20.3.tar.gz"
    mirror "https://fossies.org/linux/misc/legacy/otp_doc_man_20.3.tar.gz"
    sha256 "17e0b2f94f11576a12526614a906ecad629b8804c25e6c18523f7c4346607112"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_20.3.tar.gz"
    mirror "https://fossies.org/linux/misc/legacy/otp_doc_html_20.3.tar.gz"
    sha256 "8099b62e9fa24b3f90eaeda151fa23ae729c8297e7d3fd8adaca865b35a3125d"
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
      --enable-kernel-poll
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

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
