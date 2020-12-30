class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.12.0.tar.gz"
  sha256 "f56d51b2c33a9c03f1b9d4fc5f7480f1c2104ef1e8f04def84a16f35d0bc42f6"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 3
  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "8b8d3b6840f59625a668ee3da9bf335ef6be785386d8b7fbb2ad3c07c1220c78" => :big_sur
    sha256 "dcfabcbe448f15fe82dfeac2c9378fa7c9cc38bd69120453a0dff464a0672547" => :arm64_big_sur
    sha256 "26eb012deedfd145e01f71a2cb44ee2cc2782968585f8a9846e2e891359d31cc" => :catalina
    sha256 "cb4497e2e54831dbc98836a234a3ab627a16257a4025b5ced74bc417ae1d014a" => :mojave
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
        inreplace "Makefile", "blib/", "$(shell pwd)/blib/" if r.name == "TermReadKey"
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
