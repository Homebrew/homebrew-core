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
    sha256 cellar: :any,                 arm64_ventura:  "72211d3544c62fc8e10326ef3ac3c29e107f6f8077fa3a6d161e3a165722a787"
    sha256 cellar: :any,                 arm64_monterey: "137ae019333c6ce5088dd939f04f503d70f99a9a51411130b657243d9a642af5"
    sha256 cellar: :any,                 arm64_big_sur:  "564fd216e21cce8ce52cf11bcc0b7043a7b8cbc84db57cf84a4b67d450203087"
    sha256 cellar: :any,                 ventura:        "a9cec78201ddda29075169149e6faeec1563732afd291c57d2fdb14855635efa"
    sha256 cellar: :any,                 monterey:       "1fc5837c4399c6c20b2b5c2c5ab8bfb79c1fe4deb0728d17af8048e59d5c0c30"
    sha256 cellar: :any,                 big_sur:        "a7a2c06dbb860de2f03d485ee15ffec9a2073d7db7f04a5fe92f7fd8da829cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82acefcf82daf515319890718e0cebaa712c41b7df682bd83f4b696b8a44a095"
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
