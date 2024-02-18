require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  # Check if mysql-client@8.0 can be updated to latest with next version
  # if DBD::mysql > 5.003 - https://github.com/perl5-dbi/DBD-mysql/issues/375
  url "https://www.percona.com/downloads/percona-toolkit/3.5.5/source/tarball/percona-toolkit-3.5.5.tar.gz"
  sha256 "629a3c619c9f81c8451689b7840e50d13c656073a239d1ef2e5bcc250a80f884"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6bb5b6cd4b4b23b68ee688dff583ec7f86239266ee9296084cc9aa6c63f0cd3"
    sha256 cellar: :any,                 arm64_ventura:  "6a730c277a8d7e1dabfc9a8d644f6e28eb6b416d67d238e07cb20e62aec9441d"
    sha256 cellar: :any,                 arm64_monterey: "392cc5d58b83f2df591860a959d16163160e8356c5f59585a9f00a3607260f0a"
    sha256 cellar: :any,                 sonoma:         "7ec024c441956d3dad59afdbbad08340dfa9cf806e5cab1bff4a3d29b901fdcf"
    sha256 cellar: :any,                 ventura:        "6199ef6d49670b9621463c6ed1c238e2e5b9141f4732ce6e6f3e63286a138b1f"
    sha256 cellar: :any,                 monterey:       "4246e5fb174b129c1dc96fe85abc3f41f560f16470ce75482e289398bb58dd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbb1879e552c4bd7904097d0016f18462fd1df7901a9ff2f64a94f800b55ba5"
  end

  depends_on "mysql-client@8.0"
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
