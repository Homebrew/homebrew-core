class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "http://www.mysqlfanboy.com/mytop-3/"
  url "http://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  revision 7

  bottle do
    cellar :any
    rebuild 1
    sha256 "873b88c76650758b49e1749e35c765b5179ffd371ab489f146b35da1e3620029" => :mojave
    sha256 "8d64c44dcfccde35179d48a1698f0108df3c621e68ee7f8716a6d6db35cc1448" => :high_sierra
    sha256 "26a4812e17d0285a28176d8bd735e06a1196a794c7cefb4837f7ab9a9ed4272d" => :sierra
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  conflicts_with "mariadb", :because => "both install `mytop` binaries"

  resource "List::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.46.tar.gz"
    sha256 "30662b1261364adb317e9a5bd686273d3dd731e3fda1b8e894802aa52e0052e7"
  end

  resource "Config::IniFiles" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.94.tar.gz"
    sha256 "d6d38a416da79de874c5f1825221f22e972ad500b6527d190cc6e9ebc45194b4"
  end

  # In Mojave, this is not part of the system Perl anymore
  if MacOS.version >= :mojave
    resource "DBI" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.641.tar.gz"
      sha256 "5509e532cdd0e3d91eda550578deaac29e2f008a12b64576e8c261bb92e8c2c1"
    end
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
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match "username you specified", pipe_output("#{bin}/mytop 2>&1")
  end
end
