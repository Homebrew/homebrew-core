class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "https://web.archive.org/web/20200221154243/www.mysqlfanboy.com/mytop-3/"
  url "https://web.archive.org/web/20150602163826/www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  license "GPL-2.0-or-later"
  revision 10

  livecheck do
    skip "Upstream is gone and the formula uses archive.org URLs"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95cae0d00535b950fa6acbee1d71245ccd3c317d6e093b02d3f2825695c1184a"
    sha256 cellar: :any,                 arm64_big_sur:  "bb4ffddb44d5c033ba5d6f4b7eaffedea0ff65135d5821670ae45aef27f98597"
    sha256 cellar: :any,                 monterey:       "8a351d6782b1bced697a6b8fabb5e783cede75af65045fc1ea36ee0566c07cc1"
    sha256 cellar: :any,                 big_sur:        "4ba3994df3e4a0405b034c1c06fb4a5461e2df548e2505ffd30f5fbcbebd7728"
    sha256 cellar: :any,                 catalina:       "b4d4e1e616b63afec015e21ce0d47265dbfad454304743700e333b75dd95ca1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3deb6ff1c4a196fcef50e50ac1fd2c0240a64be2003852226400aa641845ca37"
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  on_linux do
    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  conflicts_with "mariadb", because: "both install `mytop` binaries"

  resource "List::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.46.tar.gz"
    sha256 "30662b1261364adb317e9a5bd686273d3dd731e3fda1b8e894802aa52e0052e7"
  end

  resource "Config::IniFiles" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.94.tar.gz"
    sha256 "d6d38a416da79de874c5f1825221f22e972ad500b6527d190cc6e9ebc45194b4"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.641.tar.gz"
    sha256 "5509e532cdd0e3d91eda550578deaac29e2f008a12b64576e8c261bb92e8c2c1"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  # Pick up some patches from Debian to improve functionality & fix
  # some syntax warnings when using recent versions of Perl.
  patch do
    url "https://deb.debian.org/debian/pool/main/m/mytop/mytop_1.9.1-2.debian.tar.xz"
    sha256 "9c97b7d2a2d4d169c5f263ce0adb6340b71e3a0afd4cdde94edcead02421489a"
    apply "patches/01_fix_pod.patch",
          "patches/02_remove_db_test.patch",
          "patches/03_fix_newlines.patch",
          "patches/04_fix_unitialized.patch",
          "patches/05_prevent_ctrl_char_printing.patch",
          "patches/06_fix_screenwidth.patch",
          "patches/07_add_doc_on_missing_cli_options.patch",
          "patches/08_add_mycnf.patch",
          "patches/09_q_is_quit.patch",
          "patches/10_fix_perl_warnings.patch",
          "patches/13_fix_scope_for_show_slave_status_data.patch"
  end

  def install
    res = resources
    if OS.mac? && (MacOS.version < :mojave)
      # Before Mojave, DBI was part of the system Perl
      res -= [resource("DBI")]
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    res.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    assert_match "username you specified", pipe_output("#{bin}/mytop 2>&1")
  end
end
