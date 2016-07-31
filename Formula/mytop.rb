class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "http://www.mysqlfanboy.com/mytop-3/"
  url "http://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "67a7e69f19a610123bd0dbd3fc9ffac02ee39a61c03e0b1c7c2760705d9c84a9" => :el_capitan
    sha256 "610b2021a5a02b923e22a99d156f2246b315b759f01f34b507b5e3a585c40d38" => :yosemite
    sha256 "9882bc7674838f879ff5c8342bab1cdbd284b60e7d250f0bb49cc568be6ee373" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  conflicts_with "mariadb", :because => "both install `mytop` binaries"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    sha256 "b7eca365ea16bcf4c96c2fc0221304ff9c4995e7a551886837804a8f66b61937"
  end

  resource "Config::IniFiles" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.93.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.93.tar.gz"
    sha256 "2fc79e5616c176b97f49f3d57b8d8068695639209ff9de7aa7f28a550d0478e4"
  end

  # Pick up some patches from Debian to improve functionality & fix
  # some syntax warnings when using recent versions of Perl.
  patch do
    url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mytop/mytop_1.9.1-2.debian.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mytop/mytop_1.9.1-2.debian.tar.xz"
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
