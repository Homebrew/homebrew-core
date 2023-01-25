require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.1/source/tarball/percona-toolkit-3.5.1.tar.gz"
  sha256 "4268ed0ea045e4fc76d4ba69d7c6e5bf5f5302f6441df3bc7d78b3cad860ccc4"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://www.percona.com/downloads/percona-toolkit/LATEST/"
    regex(%r{value=.*?percona-toolkit/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c493b81d20cab1851d6e5f923dd23f3cec879b8ba46c3574b2786eda1c9c953"
    sha256 cellar: :any,                 arm64_monterey: "f849be8d3203e63701b95b3cfa6d9aba36a24ed88f526b9863e35173b46f0b7c"
    sha256 cellar: :any,                 arm64_big_sur:  "87080f02e2653b0f093b5356bbb7f4d06f64ed0ad5e4f11d227d06f7e7377d8a"
    sha256 cellar: :any,                 ventura:        "56709b1894a9664adad7d6f460fa190dbe8d739da6833d1c76ab60c0bab6ed4b"
    sha256 cellar: :any,                 monterey:       "afcef465e217bfc2a944878be9056476d5f3df418d91f8e0ea63240cb8812f77"
    sha256 cellar: :any,                 big_sur:        "cc83ed13cbbc25ae172fe051a34031404726b4b5b0fd90774628ef0e3d76bdad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef2f96cd5871f0a9a82636fca63229391a6c7788a9006a1405c0efb89c6e1e7"
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
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
