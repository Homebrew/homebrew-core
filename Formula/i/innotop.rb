class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 10
  head "https://github.com/innotop/innotop.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2cf3437f299eb15b2f9d8ece6b1c1b1374e4cc8eda2fe88c47a0e11369613a9d"
    sha256 cellar: :any,                 arm64_sonoma:  "390ca18492dc10b16ce2ec36c8a60d65379fa9016788e53031adac8473af4a27"
    sha256 cellar: :any,                 arm64_ventura: "8aa57cd530906c93f6bf1b53cdfccbca76a6eae059fb999e5126e704fbbd2e79"
    sha256 cellar: :any,                 sonoma:        "0e4b35966c92c4e9fe82c91240aab1b285bbb63b48916326797becb2ce4b4e2b"
    sha256 cellar: :any,                 ventura:       "1644adc048383f4e30f415cdf1fdaf048153d9586ddcd919467b768b7b4b4e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4297dcd2edc58800032abfba5b2a89c1983a9ce79b8ca00679343c7b3c34afc4"
  end

  depends_on "mysql-client"

  uses_from_macos "perl"

  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.645.tgz"
      sha256 "e38b7a5efee129decda12383cf894963da971ffac303f54cc1b93e40e3cf9921"
    end
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.009.tar.gz"
    sha256 "8552d90dfddee9ef36e7a696da126ee1b42a1a00fbf2c6f3ce43ca2c63a5b952"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        install_base = (r.name == "Devel::CheckLib") ? buildpath/"build_deps" : libexec

        # Skip installing man pages for libexec perl modules to reduce disk usage
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"

        make_args = []
        if OS.mac? && r.name == "DBD::mysql"
          # Reduce overlinking on macOS
          make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs"
          # Work around macOS DBI generating broken Makefile
          inreplace "Makefile" do |s|
            old_dbi_instarch_dir = s.get_make_var("DBI_INSTARCH_DIR")
            new_dbi_instarch_dir = "#{MacOS.sdk_path_if_needed}#{old_dbi_instarch_dir}"
            s.change_make_var! "DBI_INSTARCH_DIR", new_dbi_instarch_dir
            s.gsub! " #{old_dbi_instarch_dir}/Driver_xst.h", " #{new_dbi_instarch_dir}/Driver_xst.h"
          end
        end

        system "make", "install", *make_args
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
