require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.3.1/source/tarball/percona-toolkit-3.3.1.tar.gz"
  sha256 "60fc106b195b6716f1ebb3ca16b401692228c1a2a885da72111a93391fd12090"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://www.percona.com/downloads/percona-toolkit/LATEST/"
    regex(%r{value=.*?percona-toolkit/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f6bb6f309b86e299dd07068d8ffbc4f522211710c583256c5b7528ee24eb436"
    sha256 cellar: :any,                 arm64_big_sur:  "c4894d911c4f3e0adad36c3f2aa3a67e74dd309faadb6dffb7c9ce543944bc2e"
    sha256 cellar: :any,                 monterey:       "344ba40041a33e4b8daf56129ebf4523b5c198d43ea064c5aebb59c997183497"
    sha256 cellar: :any,                 big_sur:        "9274b60c27cacce29aec88b890899ab988f003ae440108fe919692d0f852ea57"
    sha256 cellar: :any,                 catalina:       "93c759128255833a67e8b365610eb8ccb4877d82f1bf66176ad4b597b90217fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccfdd6284fc9a2c1226cb148a446180209d48b7b9070ea5b4779f429a31c984"
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz"
    sha256 "f21c5e299ad3ce0fdc0cb0f41378dca85a70e8d6c9a7599f0e56a957200ec294"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.03.tar.gz"
    sha256 "e41f8761a5e7b9b27af26fe5780d44550d7a6a66bf3078e337d676d07a699941"
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
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}"
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

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
