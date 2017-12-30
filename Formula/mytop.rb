class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "http://www.mysqlfanboy.com/mytop-3/"
  url "http://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  revision 4

  bottle do
    cellar :any
    sha256 "5921bbce36cc99fba2b22daa784a3dbff556a1fd57d2f9f54e46e6650d32d8cc" => :high_sierra
    sha256 "e49071ca46a5f8203d24ea318afab37b6a387f5669b69cca670a0b053e1c7611" => :sierra
    sha256 "4fca8e6d7cf86993af8dcded0b4ce5bc0b4a3fb63ec2359c42d0513019ec03e0" => :el_capitan
    sha256 "869b2a25dd9cd7fdeadce32336e8c8ff0d90545a78fedbd6c9a870c0910b2521" => :yosemite
  end

  depends_on "mysql"
  depends_on "openssl"

  conflicts_with "mariadb", :because => "both install `mytop` binaries"

  resource "List::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.46.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.46.tar.gz"
    sha256 "30662b1261364adb317e9a5bd686273d3dd731e3fda1b8e894802aa52e0052e7"
  end

  resource "Config::IniFiles" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.94.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SH/SHLOMIF/Config-IniFiles-2.94.tar.gz"
    sha256 "d6d38a416da79de874c5f1825221f22e972ad500b6527d190cc6e9ebc45194b4"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.041.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.041.tar.gz"
    sha256 "4777de11c464b515db9da95c08c225900d0594b65ba3256982dc21f9f9379040"
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
