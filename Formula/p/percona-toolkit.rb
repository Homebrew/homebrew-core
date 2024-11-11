class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.6.0/source/tarball/percona-toolkit-3.6.0.tar.gz"
  sha256 "48c2a0f7cfc987e683f60e9c7a29b0ca189e2f4b503f6d01c5baca403c09eb8d"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 2
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3980109fd839e015ba0374ce6ab91d38b1e3dbf19adbd0dbd9419ff22c6d7c6b"
    sha256 cellar: :any,                 arm64_sonoma:  "132b777b091235c5cfb076fcb1e598779b9c85b5474ab4bd835a41505bf90913"
    sha256 cellar: :any,                 arm64_ventura: "8d602577ed2a44397000a5f7c6681fedd6d877ae216397832ca56845e1605db3"
    sha256 cellar: :any,                 sonoma:        "dc1b543213e20d1c89fa03feed8db8c1d4389d9af301bd09f53ab7ec8b7465df"
    sha256 cellar: :any,                 ventura:       "e02f9d93dc0f420f69948e2ec983cf448b6e4ab65b32f111e1b7ba99d124f70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3d4c95c44bb34b52568ea62819f57a19988ba50622c5c87b82a7a236606407"
  end

  depends_on "go" => :build
  depends_on "mysql-client"

  uses_from_macos "perl"

  # Should be installed before DBD::mysql
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

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_only_deps = %w[Devel::CheckLib]
    resources.each do |r|
      r.stage do
        install_base = if build_only_deps.include? r.name
          buildpath/"build_deps"
        else
          libexec
        end

        # Skip installing man pages for libexec perl modules to reduce disk usage
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}",
                                      "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none",
                                      "NO_PERLLOCAL=1", "NO_PACKLIST=1"

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
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}/pt-online-schema-change --version")
  end
end
