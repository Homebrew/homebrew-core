class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.11/source/tarball/percona-toolkit-3.0.11.tar.gz"
  sha256 "934500d0fdd5fdb94885ca5d8e96cf386ccec279536eea84b242c5db83023cd6"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "8fa11e59ef5baf5959f39cf09b76940594a93531577f18ed75d6918e6300179c" => :high_sierra
    sha256 "d5a00c77e0acafcbe858739097860bbb515b9d2ca12d517bd75850a99816cd66" => :sierra
    sha256 "9e5c18b1b7d2087ebacd1ece7f5e39489efbb52e052551230d9a9d6a9747dd88" => :el_capitan
  end

  depends_on "mysql-client"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
    sha256 "e277d9385633574923f48c297e1b8acad3170c69fa590e31fa466040fc6f8f5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
