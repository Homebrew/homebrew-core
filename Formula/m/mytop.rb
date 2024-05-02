class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "https://www.mysqlfanboy.com/mytop-3/"
  url "https://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mytop/1.9.1-5/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  license "GPL-2.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cfcc1cb5ec497d290bc9cd24b459dbae81251f26ff9a29294fa032297da3206c"
    sha256 cellar: :any,                 arm64_ventura:  "a2e750cd273cfb1d3110dddfd70a4937dd6d7242d2a83d3ee172155d297c550d"
    sha256 cellar: :any,                 arm64_monterey: "544c937403f18212d99c8835b30fde5736aa4ee3387fc67788a23a4e23deb208"
    sha256 cellar: :any,                 arm64_big_sur:  "4a09f6e45e3878f24acc90d480520e8b0499bab96ec5226af695b93657fef79e"
    sha256 cellar: :any,                 sonoma:         "26c480c31a6487799df197d3e8eece7754afc7013876cc80f2edac0286266ff8"
    sha256 cellar: :any,                 ventura:        "e93ba00dce926fef622407103246a0f86e1fe7766512754db65c8e39e8bd41e6"
    sha256 cellar: :any,                 monterey:       "1e12316b18917e634d08d1edea087b82fa33c8ec1f26cfad09ea69d9404c8407"
    sha256 cellar: :any,                 big_sur:        "e28bdce153b9d901145a85ec86be714b8d1f63a12354dd6db995e56f509cbf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "910aa0172b9f4e1d89c49e24fcafe357d841047bc9fc9cda2307e1c78e54fc3c"
  end

  disable! date: "2024-02-22", because: :unmaintained

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  conflicts_with "mariadb", because: "both install `mytop` binaries"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "Config::IniFiles" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-3.000003.tar.gz"
    sha256 "3c457b65d98e5ff40bdb9cf814b0d5983eb0c53fb8696bda3ba035ad2acd6802"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  # Pick up some patches from Debian to improve functionality & fix
  # some syntax warnings when using recent versions of Perl.
  patch do
    url "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mytop/1.9.1-5/mytop_1.9.1-5.debian.tar.xz"
    sha256 "e9ded218aefeefdf7acd29a4f6a895f7ff06c34dde1364dbdc9663b56cc69155"
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
          "patches/11_fix_url_manpage.patch",
          "patches/12_fix_spelling_and_allignment.patch",
          "patches/13_fix_scope_for_show_slave_status_data.patch",
          "patches/14_fix_deprecated_show_innodb_status.patch"
  end

  def install
    res = resources
    if OS.mac? && (MacOS.version < :mojave)
      # Before Mojave, DBI was part of the system Perl
      res -= [resource("DBI")]
    end

    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_only_deps = %w[Devel::CheckLib]
    res.each do |r|
      r.stage do
        install_base = if build_only_deps.include? r.name
          buildpath/"build_deps"
        else
          libexec
        end
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}"
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
