class ErlangAT21 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-21.3.8.24/otp_src_21.3.8.24.tar.gz"
  sha256 "a82de871d7ba40fd256558b23a3b4c1539e6c7ece7507d6eb2b00330c6135012"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 monterey:     "9effd9cdb8786f80257db78e9d1c587e4065313628f6c04c1ffe588afe0d9953"
    sha256 cellar: :any,                 big_sur:      "f05c014c491877da25d19f775a576803a25c36c5d57309548711c253b90711c8"
    sha256 cellar: :any,                 catalina:     "042070fc8af915df870a67f1eaa43e87beacd3bcf4c8cde8d78bbe1e195cf133"
    sha256 cellar: :any,                 mojave:       "03315a212e5e5ddcb5bf37d45faacd0ce075d6a2503217f42f5eda083ebacec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c76e5cd284dfb658a962b06b5aae7d5aefa1d50e2feab458f66f64542f5b719b"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-03-01", because: :unsupported

  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64
  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_21.3.tar.gz"
    sha256 "f5464b5c8368aa40c175a5908b44b6d9670dbd01ba7a1eef1b366c7dc36ba172"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_21.3.tar.gz"
    sha256 "258b1e0ed1d07abbf08938f62c845450e90a32ec542e94455e5d5b7c333da362"
  end

  # Fix build on Xcode 11.4+ (https://bugs.erlang.org/browse/ERL-1205)
  patch do
    url "https://github.com/erlang/otp/commit/3edba0dad391431cbadad44a8bd15c75254fc239.patch?full_index=1"
    sha256 "0c82d9f3bdb668ba78025988c9447bebe91a2f6bb00daa7f0ae7bd1916cd9bfd"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

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
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
