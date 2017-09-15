class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-20.0.5.tar.gz"
  sha256 "45b6966362c3a4da292d470ef25af9f91b851d4e96d3736abdabbba0556acf6c"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "748b5587be6cdbf99a265e94ea17ba78a9c4db374d3864215b6e5c8223f06704" => :sierra
    sha256 "63a042bed6484443abd07f207f310ff80a3f65766f98b90b354d364bb936210b" => :el_capitan
    sha256 "7bd021553ac3f1a47dc4500715d54b74fc5f773669ba925df5f9fc1a5b6b53d1" => :yosemite
  end

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "fop" => :optional # enables building PDF docs
  depends_on :java => :optional
  depends_on "wxmac" => :recommended # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_20.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_20.0.tar.gz"
    sha256 "b7f1542a94a170f8791f5d80a85706f9e8838924ea65d4301032d0c0cfb845cc"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_20.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_20.0.tar.gz"
    sha256 "1ab25110b148ce263d6e68cd5a3b912299b6066cfcd9d2fce416a4e9b7d2543a"
  end

  # Check if this patch can be removed when OTP 20.1 is released.
  # Erlang will crash on macOS 10.13 any time the crypto lib is used.
  # The Erlang team has an open PR for the patch but it needs to be applied to
  # older releases. See https://github.com/erlang/otp/pull/1501 and
  # https://bugs.erlang.org/browse/ERL-439 for additional information.
  patch do
    url "https://github.com/erlang/otp/pull/1501.patch?full_index=1"
    sha256 "e449d698a82e07eddfd86b5b06a0b4ab8fb4674cb72fc6ab037aa79b096f0a12"
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

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
