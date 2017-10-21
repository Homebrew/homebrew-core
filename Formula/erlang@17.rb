class ErlangAT17 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/erlang/otp/archive/OTP-17.5.6.9.tar.gz"
  sha256 "70d9d0a08969f4c51c78088f8c6b7da22a4806b1fd258a9fff1408f56553f378"
  head "https://github.com/erlang/otp.git", :branch => "maint-17"

  bottle do
    cellar :any
    sha256 "de3143035b8e4861f90f3cdd2e6a518d97bc17f7b1087948026b99bc36b781fe" => :high_sierra
    sha256 "819a566e39049cb521e3a26f39746258d333acd4ce9bc91eff2dc8969905f2fc" => :sierra
    sha256 "e4faf6f98903c5dd7fa4894f7a61f722101119572f6d32ab9000fa47332f148d" => :el_capitan
    sha256 "ab5c9f75b67c92c103a7712104edf8dd4f6edb52eda6d0312b50bde0e1f83780" => :yosemite
  end

  keg_only :versioned_formula

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "without-docs", "Do not install documentation"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "unixodbc" if MacOS.version >= :mavericks
  depends_on "fop" => :optional # enables building PDF docs
  depends_on "wxmac" => :recommended # for GUI apps like observer

  # Erlang will crash on macOS 10.13 any time the crypto lib is used.
  # The Erlang team has an open PR for the patch but it needs to be applied to
  # older releases. See https://github.com/erlang/otp/pull/1501 and
  # https://bugs.erlang.org/browse/ERL-439 for additional information.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8cf3045/erlang%4017/boring-ssl-high-sierra.patch"
    sha256 "ec4bbdabdfece3a273210727bc150e0e588479885a141382b4d54221bbec5fc3"
  end

  # Pointer comparison triggers error with Xcode 9
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/erlang/otp/commit/a64c4d806fa54848c35632114585ad82b98712e8.diff?full_index=1"
      sha256 "3261400f8d7f0dcff3a52821daea3391ebfa01fd859f9f2d9cc5142138e26e15"
    end
  end

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_17.5.tar.gz"
    sha256 "85b1b2a1011fc01af550f1fe9e5a599a4c5f2a35d264d2804af1d05590a857c3"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_17.5.tar.gz"
    sha256 "baba1d373c1faacf4a1a6ec1220d57d0cb2b977edb74f32cd58dc786361c6cf5"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on macOS
      # https://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # https://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Install is not thread-safe; can try to create folder twice and fail
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
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
