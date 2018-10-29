class ErlangAT18 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/erlang/otp/archive/OTP-18.3.4.10.tar.gz"
  sha256 "994c8aa2931d4d7ad473c68d1be31ec9e7faa96a2859f253225c3b33226dfcba"

  bottle do
    cellar :any
    sha256 "35ca0e0acbecd171e586bcebb53b2313ca02fc756b390d750cc73ee86f8f6702" => :mojave
    sha256 "2a379d09b405738143d3f05a719738e2cac285107e1c5115ae6bceb301ef1c44" => :high_sierra
    sha256 "3d70eb44b2d7e4038d85c946973b57fd1bc0ddfb638e4f84b001393d3bcbc699" => :sierra
    sha256 "66f38b4af3fc08e302d421d1bd4bd5e40125d920968a46c1aed7d4056ec7a033" => :el_capitan
  end

  keg_only :versioned_formula

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac" => :recommended # for GUI apps like observer
  depends_on "fop" => :optional # enables building PDF docs
  depends_on :java => :optional

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_18.3.tar.gz"
    sha256 "978be100e9016874921b3ad1a65ee46b7b6a1e597b8db2ec4b5ef436d4c9ecc2"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_18.3.tar.gz"
    sha256 "8fd6980fd05367735779a487df107ace7c53733f52fbe56de7ca7844a355676f"
  end

  # Check if this patch can be removed when OTP 18.3.5 is released.
  # Erlang will crash on macOS 10.13 any time the crypto lib is used.
  # The Erlang team has an open PR for the patch but it needs to be applied to
  # older releases. See https://github.com/erlang/otp/pull/1501 and
  # https://bugs.erlang.org/browse/ERL-439 for additional information.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/774ad1f/erlang%4018/boring-ssl-high-sierra.patch"
    sha256 "7cc1069a2d9418a545e12981c6d5c475e536f58207a1faf4b721cc33692657ac"
  end

  # Pointer comparison triggers error with Xcode 9
  patch do
    url "https://github.com/erlang/otp/commit/a64c4d806fa54848c35632114585ad82b98712e8.diff?full_index=1"
    sha256 "3261400f8d7f0dcff3a52821daea3391ebfa01fd859f9f2d9cc5142138e26e15"
  end

  def install
    # Fixes "dyld: Symbol not found: _clock_gettime"
    # Reported 17 Sep 2016 https://bugs.erlang.org/browse/ERL-256
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["erl_cv_clock_gettime_monotonic_default_resolution"] = "no"
      ENV["erl_cv_clock_gettime_monotonic_try_find_pthread_compatible"] = "no"
      ENV["erl_cv_clock_gettime_wall_default_resolution"] = "no"
    end

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

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Install is not thread-safe; can try to create folder twice and fail
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
