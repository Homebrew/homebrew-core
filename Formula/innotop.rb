class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 4
  head "https://github.com/innotop/innotop.git"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "068773ea3da98de5fe42044cc0520afdddedfa7c84fb5e62108b1720b9c20248"
    sha256 cellar: :any,                 arm64_monterey: "77425886a3180aa4b961083035c3e6425d85dbfb387bdf569f0573120ea34943"
    sha256 cellar: :any,                 arm64_big_sur:  "278185fd679a22585d66d86d28e08db84bd49ddb720c070826b25588dd4aeb6b"
    sha256 cellar: :any,                 ventura:        "e7234b7ec0b3464de544936ab873a2370c862cb84a4cc97263e7f20187aa7585"
    sha256 cellar: :any,                 monterey:       "af869d75e218b48c71d8cf9f7ed87b9298776fdd17dfa0586f890d3610e45e45"
    sha256 cellar: :any,                 big_sur:        "60a364a7d80d3918c6d8b52ceeb4fa78bcfe84c200dc8705a8c756b32b8f2a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2cb1f63384bafc63123f727a97a9dc5ab18d4c17814b94050d1f698795c187"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

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

  resource "TermReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        # Work around restriction on 10.15+ where .bundle files cannot be loaded
        # from a relative path -- while in the middle of our build we need to
        # refer to them by their full path.  Workaround adapted from:
        #   https://github.com/fink/fink-distributions/issues/461#issuecomment-563331868
        inreplace "Makefile", "blib/", "$(shell pwd)/blib/" if OS.mac? && r.name == "TermReadKey"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    inreplace "innotop", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
