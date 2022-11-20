require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.4.0/source/tarball/percona-toolkit-3.4.0.tar.gz"
  sha256 "330c56723d4e6b966d0ad89f556efdf867a46f89462dd894eda331596aa88008"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://www.percona.com/downloads/percona-toolkit/LATEST/"
    regex(%r{value=.*?percona-toolkit/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bff64388cdaa376adbcf4eabd06ac3c5fed17d2399fe8936bdc4db1116d14732"
    sha256 cellar: :any,                 arm64_monterey: "02b8645c31c1dbc613049b92beea76566521953538733109d749c86bb9178902"
    sha256 cellar: :any,                 arm64_big_sur:  "cc026046227611a83c3f3d081d15119a83a518eec51d5626dc80b995a5314d42"
    sha256 cellar: :any,                 ventura:        "6264f1f333980feac0fbb093f4c2a6542c5a608d3bcc40f28f02bc63280a706b"
    sha256 cellar: :any,                 monterey:       "f5768c6c6498278a2fafca391fe498ff8c6cd06e2463cf22a5bfead8b8d23799"
    sha256 cellar: :any,                 big_sur:        "31a91aef0643e348de8653b5563c1897f484a83d18172eb42f9fdc12c832f498"
    sha256 cellar: :any,                 catalina:       "bc616aebe1a63d674e4fe0c366425a42c13d4b0020696b698be0636cc87bb819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01ccdce731c74a3b19d37dde24a9854afe3e51431f7d53eb215caf974423a70"
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
