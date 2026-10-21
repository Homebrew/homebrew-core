class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.7.tar.gz"
  sha256 "8dbe11e5858b8c1aab7bd670bc39a3483accd09e147d3dd981fe11a7fa0d10de"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db3f55d755f154a5fef8c0d754985dbf23d53aca67c0d301e564826a1303a201"
    sha256 cellar: :any, arm64_tahoe:       "2d199dbae3ac05667fc94351a2a07a16bd49b9cba698aa2d4e9ded70139db1dd"
    sha256 cellar: :any, arm64_sequoia:     "54c50b3a1a414ee3fdaba86f3388c951457d2c8fb51f5257286893653d95e223"
    sha256 cellar: :any, arm64_linux:       "9c5314fe1c462d3af36e8a6eed9ebe21fdcf39195b30c0695dff139e445eb7a0"
    sha256 cellar: :any, x86_64_linux:      "630a3e26e5ca96e0237a6a1df562ee87a7ef8037a5673e713364e8d7f0f4379e"
  end

  depends_on "pkgconf" => :build
  depends_on "libssh"
  depends_on "mariadb-connector-c"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  def install
    # macOS auto-detects Homebrew library paths but not the system curses headers;
    # Linux auto-detects neither. Point configure at the right paths per platform.
    # https://github.com/vanhauser-thc/thc-hydra/issues/80
    config = if OS.mac?
      {
        "CURSES_PATH"  => "#{MacOS.sdk_path}/usr/lib",
        "CURSES_IPATH" => "#{MacOS.sdk_path}/usr/include",
      }
    else
      {
        "CRYPTO_PATH"  => formula_opt_lib("openssl@4"),
        "CURSES_PATH"  => formula_opt_lib("ncurses"),
        "CURSES_IPATH" => formula_opt_include("ncurses"),
        "MYSQL_PATH"   => formula_opt_lib("mariadb-connector-c"),
        "MYSQL_IPATH"  => "#{formula_opt_include("mariadb-connector-c")}/mariadb",
        "PCRE_PATH"    => formula_opt_lib("pcre2"),
        "PCRE_IPATH"   => formula_opt_include("pcre2"),
        "SSL_PATH"     => formula_opt_lib("openssl@4"),
        "SSL_IPATH"    => formula_opt_include("openssl@4"),
        "SSH_PATH"     => formula_opt_lib("libssh"),
        "SSH_IPATH"    => formula_opt_include("libssh"),
        "SSLNEW"       => "YES",
      }
    end

    inreplace "configure" do |s|
      config.each { |var, value| s.change_make_var!(var, value) }

      # Avoid opportunistic linking of everything
      avoid_libs = %w[libfreerdp libgcrypt libidn libmemcached libmongoc libpq libsvn sybdb sybfront]
      avoid_libs.each { |lib| s.gsub!(lib, "oh_no_you_dont") }
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--disable-xhydra", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    output = shell_output(bin/"hydra", 255)
    assert_match "mysql", output
    assert_match "ssh", output
  end
end
