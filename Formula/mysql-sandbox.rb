class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  stable do
    url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.02.tar.gz"
    sha256 "47b5a54b36c767f9898c991fc3de4c7b143d650ba6105a69cd4fefdc2ae8a543"

    # Fix the version
    # Upstream commit "Fixed download parameter for make_sandbox_from_url"
    patch do
      url "https://github.com/datacharmer/mysql-sandbox/commit/f6a9b03.patch"
      sha256 "811a1ff6aa49c0e679df78edd51a78f6f13f6d1b0cf5dcfb2be632aa479dd151"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "64035c68f186826da58b7c5960589e472cb3a9a87c0708ec3f66851a4a51216c" => :el_capitan
    sha256 "e7523eabf61bcd519c1d7d7faa7c28d28c562bb946594c37f6e1a22c2138a9d6" => :yosemite
    sha256 "226208df982aa899b9835cf8938d40151d4e8256392098aba057b4211299f167" => :mavericks
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
