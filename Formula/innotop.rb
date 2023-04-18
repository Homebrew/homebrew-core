class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 3
  head "https://github.com/innotop/innotop.git"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "514880fb1328de2d2aa76e929e5059c014aeee67b1355a35c04c85897d5feb38"
    sha256 cellar: :any,                 arm64_monterey: "750258fa6cdba7d0c1f5b1c63c6f7147b71fd0c011143ac4aaf0e79de9a3db81"
    sha256 cellar: :any,                 arm64_big_sur:  "3afc923395e6a125d9935d135b94b733512645155cd25f366a70b1f7e542b430"
    sha256 cellar: :any,                 ventura:        "5580dfd4ea884c197b54a07a7f8c3a80b10d5864e8c1950c71cf0e84e88c8e19"
    sha256 cellar: :any,                 monterey:       "cca41045f9fd17f918ddd019e901ccdf7378af84432569678de80a2f20a78a6c"
    sha256 cellar: :any,                 big_sur:        "80dd83b847117c4134cfe92cbea270feab5d982cacf02589bdbe968c358d6998"
    sha256 cellar: :any,                 catalina:       "37d9c2e484c05d25308a5868af10f09d8dc7641ca88b8fa68ca2d3372f1c1545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cee83a61c30303263741258a618a9e7ae45c7737c9a54ab2bed264a031cfaae"
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
