require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.5/source/tarball/percona-toolkit-3.5.5.tar.gz"
  sha256 "629a3c619c9f81c8451689b7840e50d13c656073a239d1ef2e5bcc250a80f884"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0762888134304fa077823d51393d367658135f447a3b99eec824e6fa91ab9b4"
    sha256 cellar: :any,                 arm64_ventura:  "0a05af6d3c4557487e0ee7af75d639660929edb750701bfff3fd7726a2650943"
    sha256 cellar: :any,                 arm64_monterey: "16e5e49279be074cb9dc3aa66ccb10e683b55691d291626f3e86872b1a9a7b35"
    sha256 cellar: :any,                 sonoma:         "1569cc102d0ac56785bba4cdb144d1eee9eed17336cb79f64d281c4b5c7e8ce1"
    sha256 cellar: :any,                 ventura:        "fe4764533d14ac5c46a944c15f7086b579d257a298a828c131e2daf998a6d71b"
    sha256 cellar: :any,                 monterey:       "638fd29497b2bb281b8778831cd3be2f8f52b265b114f962d8ccc872ec05bb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc312a085262d7450a5066fae822f4089007754e2d006e4d30dc3783b95bdbc"
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
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.001.tar.gz"
    sha256 "bf6411d26301c6361d48ebbf5cfaa09805de7ded5da3eb280089c00ade4449d4"
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
