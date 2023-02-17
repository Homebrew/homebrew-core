class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.2.3/otp_src_25.2.3.tar.gz"
  sha256 "f4d9f11d67ba478a053d72e635a44722a975603fe1284063fdf38276366bc61c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fae10ce63eec4d616ad05434cb42c695a84d4a136a3a96e0b4879125c5e0b0a2"
    sha256 cellar: :any,                 arm64_monterey: "528c010adaf958c8ffab1254d8192b035aa69b4be9b8c16c5ff1334d3c6c06d9"
    sha256 cellar: :any,                 arm64_big_sur:  "570dddf7e4a1c4019a058a2078664c4ee02f5ae8db19ad99a14dce27201deca3"
    sha256 cellar: :any,                 ventura:        "199e8d1553731f72301538d4cad660d735396544927a7e54a89820df4ace143c"
    sha256 cellar: :any,                 monterey:       "908eebdb39d18e2e43dc1f569e9c2034241c367f46345a97e37557aca323d08e"
    sha256 cellar: :any,                 big_sur:        "e7a7b3f406f91fbe213e8fe6830e8d0238d2cfb4eb9b5e78e0fc7a5eb67e53d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8182f6ab185f6719dce9a4b4b5feb85bb8344c037cb0532e93787bc52797a95"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.2.2/otp_doc_html_25.2.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.2.2.tar.gz"
    sha256 "3077f209fe25034130e262c039a9c8d43773456cf49be052ee9057f870ee77e9"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

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
