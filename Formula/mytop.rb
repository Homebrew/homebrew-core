class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "https://web.archive.org/web/20200221154243/www.mysqlfanboy.com/mytop-3/"
  url "https://web.archive.org/web/20150602163826/www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  license "GPL-2.0-or-later"
  revision 11

  livecheck do
    skip "Upstream is gone and the formula uses archive.org URLs"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0eb04ca2f9d13e1c62bea17ef96e34e01189d5d1b58160105338801f205fa888"
    sha256 cellar: :any,                 arm64_monterey: "8f02659e8b735fdf311c10368016aaf4b44a6e24c830439bdff91f9bd8ac2f6c"
    sha256 cellar: :any,                 arm64_big_sur:  "75452c7d92536a9ea9f92a1a22a9271e1db9f180ffc6ac5d3504c092e91f3adc"
    sha256 cellar: :any,                 ventura:        "52a13013f86290fdd2b52f76097871d9c0c637575385ec28c94b34012b25ba22"
    sha256 cellar: :any,                 monterey:       "c5b43ff2ce82566006e3fb37f869d65d23fad64004458d2e9b3d895e8b867979"
    sha256 cellar: :any,                 big_sur:        "1d2309a462b4bbe804c4e944e4e799bafdd2e0f8d5b0095c815ec377e99b1dcd"
    sha256 cellar: :any,                 catalina:       "f376b1839b64b69043db8abe25c876b617c3d89ec1a2a8a9bc7112aa0b8d6137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e6242116e773721a6a5e8beb39c5936d6f986043118f3216a750cd3d777dfc"
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  conflicts_with "mariadb", because: "both install `mytop` binaries"

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

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
