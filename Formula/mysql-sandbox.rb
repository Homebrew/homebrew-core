class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.17.tar.gz"
  sha256 "3af4af111536e4e690042bc80834392f46a7e55c7143332d229ff2eb32321e89"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88eefc687a4a8344dfac002ea5a3183302de67d1a699324357115325f2e337cb" => :mojave
    sha256 "da11d806c9d472f19514da7520ec448210e410983225a3b41c0459634a823ab7" => :high_sierra
    sha256 "1829b23da5960830f426300cac7b4820f21a4f801a1260357394b205bb9340a4" => :sierra
    sha256 "77ab4eb3bbd5d374020081b3505cd7f18de1500019af148f00ebef13a34e4222" => :el_capitan
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
