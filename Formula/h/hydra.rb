class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.9.tar.gz"
  sha256 "aa0cac9797a745f38dc2ba580f00af7c695d46b9cf1ced6a1ae8e62ccd999f0d"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    manifest_sha256 "1432b0ef5453030dac514c0cc543c39b1e04a697935aa50fd9c1b2f09f713ce2"
    sha256 cellar: :any, arm64_golden_gate: "83a0cd0f77a09238a89762b89018570651c793353024246a5877c9a1d215378d"
    sha256 cellar: :any, arm64_tahoe:       "af750d49a27b259639ada9b434f72e7971bebab5773771a1bc49331b8ead5119"
    sha256 cellar: :any, arm64_sequoia:     "2933c0a752e290b8272ab76307f239f1319372908e08501c00275efcd1944406"
    sha256 cellar: :any, arm64_linux:       "8534107ca265fafc40ab8554c817c19b87bda0a44aa48379c34a9ba0303591bc"
    sha256 cellar: :any, x86_64_linux:      "1ee47a2677e1bc6e9a328f0f2a9b3228ddafa17c3d8199177b4e42d382cbff39"
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

  allow_network_access! :test

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
        "CRYPTO_PATH"  => dep("openssl").opt_lib,
        "CURSES_PATH"  => formula_opt_lib("ncurses"),
        "CURSES_IPATH" => formula_opt_include("ncurses"),
        "MYSQL_PATH"   => formula_opt_lib("mariadb-connector-c"),
        "MYSQL_IPATH"  => "#{formula_opt_include("mariadb-connector-c")}/mariadb",
        "PCRE_PATH"    => formula_opt_lib("pcre2"),
        "PCRE_IPATH"   => formula_opt_include("pcre2"),
        "SSL_PATH"     => dep("openssl").opt_lib,
        "SSL_IPATH"    => dep("openssl").opt_include,
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
