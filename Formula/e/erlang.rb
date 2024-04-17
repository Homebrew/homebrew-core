class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.4/otp_src_26.2.4.tar.gz"
  sha256 "b51ad69f57e2956dff4c893bcb09ad68fee23a7f8f6bba7d58449516b696de95"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3994eb40fbac7878048b54d4059188afd3a408a935b15af8f2856d45d16e9b6a"
    sha256 cellar: :any,                 arm64_ventura:  "8441158ffea98f1fae173d45aebf778a49df5af9a55b363940194094500209a8"
    sha256 cellar: :any,                 arm64_monterey: "775017ee16bc2d224cc173f8cfb1c6229d0d6672b0d96d4dc498e4528e1ae361"
    sha256 cellar: :any,                 sonoma:         "ea1f0e402ea8228755aeb0d102535f88d6a7420984a54f952443b0a3e26155f3"
    sha256 cellar: :any,                 ventura:        "2d8a045496342d12e87a6cd81bc9e18ecc70a775488468287859fa60ae80385a"
    sha256 cellar: :any,                 monterey:       "dc96479804c3516ae8311846a2cd38ec9777877215d728a5e5be8a9ad6bcc0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82929570d5c156ac6f946a50e94811353ffb2c3e1ea190f682f5a0698ae65c16"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.4/otp_doc_html_26.2.4.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_26.2.4.tar.gz"
    sha256 "db454b239b9d22fdb56a206be5be0a7b30d6939fe5490be7975006fdd668e44f"
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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
    assert_equal version, resource("html").version, "`html` resource needs updating!"

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
