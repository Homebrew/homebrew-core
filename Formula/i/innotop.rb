class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 5
  head "https://github.com/innotop/innotop.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b141f9ff15ff71a137932ce0d92782fe456f16da7797c8ea01e8d442327ef27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4435fa9d4eddf25fa938fd5a27997399340291b80b9fa0c51329ef895b6f877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3191f7604047d76c459f0c5d4f342a9a3613ddb315235f6c5d275224c1ecc55"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a2b580ecac088e1e4da1d76cb09bb41849a6b56e294e59502b64813d7045b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e4617476609c115395c72820fa66f54e8dcde160c081791ea0547312fa0d7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ee202e37395f89fa8bbdda66f08e6087d324a764034d28d51bafecfae2e093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab969696af775acad4be0288eb659937e1777d14693e766164994de8f9a86302"
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
