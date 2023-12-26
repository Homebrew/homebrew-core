require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.7/source/tarball/percona-toolkit-3.5.7.tar.gz"
  sha256 "14e3bd5b0a7e3f210d7e4fd31e7b2c817d26cea8ac80c76587b8982078158056"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "356c2ddcfd02830d02663a7e073fcca708f23a8a79e7f9b5d627a11c506a8465"
    sha256 cellar: :any,                 arm64_ventura:  "22759eb912f87d16404cadd9de43f6dedcb1b7ad2a04703e27581d3d01cfbd66"
    sha256 cellar: :any,                 arm64_monterey: "9f98c5ad1175a3a5c3d6ebfe60aa423be81ef97e96d42408dad89b3ce9fa04dd"
    sha256 cellar: :any,                 sonoma:         "9123096f65086906e48048cc4080463a2e5a414b42c3d970739417556679f229"
    sha256 cellar: :any,                 ventura:        "f428db5e4b9647ef825b166d46969efbd6efd53c63f34acc52b33dd6c084cb42"
    sha256 cellar: :any,                 monterey:       "941ac31f6fb49c95db06930027c7aac863dd2511d72232eee97f4bf009c03e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d830b67b9486645f6bc29c60fab820d67b08011fac498d7f0cd3d6ae2a0f75f6"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.002.tar.gz"
    sha256 "8dbf87c2b5b8eaf79cd16507cc07597caaf4af49bc521ec51c0ea275e8332e25"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
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
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    rewrite_shebang detected_perl_shebang, *bin.children

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
