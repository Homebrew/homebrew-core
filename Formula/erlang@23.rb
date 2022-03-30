class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.13/otp_src_23.3.4.13.tar.gz"
  sha256 "f9085856fa5c1d6b8c5385cab2fd750068206213de8cb5642ba5b3023c752fc8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29e2f79e657df38765a2d1dc10591ba851f0dc289d3fa8ca47f69ea9f282339f"
    sha256 cellar: :any,                 arm64_big_sur:  "d789898e4205dc53d99991fc5e65250a203d7aa0d85343e52fde11835be8fe93"
    sha256 cellar: :any,                 monterey:       "b77ca24355677a7dd52df7b24fedc2a4d2a4500103915ba6ee8e49ee8a20dfce"
    sha256 cellar: :any,                 big_sur:        "55ffdeacff4bf77c4c7e633147b7468c51a719c560136c672f414a7bc85b5af8"
    sha256 cellar: :any,                 catalina:       "763f08d09998b307685a68dd12700fe274f0864cbaa7ddea01df84b1a9d13c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e34b1af3a8130b2dfa0365d0c2942080a385bec59874b0671a33c0791d1921"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_23.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_23.3.tar.gz"
    sha256 "03d86ac3e71bb58e27d01743a9668c7a1265b573541d4111590f0f3ec334383e"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

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
