class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.16.tar.gz"
  sha256 "1ca551c838bff9a7a6590c518ff09d12430bdcdf6709c407c97fb201c8d4538c"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab2fac837089457394a807a03bd13900c1846f53fcc608fd0e8191591265f4f5" => :high_sierra
    sha256 "32f576413ce0eb5a52e5f119b00f9916a09d92c9e2d4bb482c8c9087a1dc2bd2" => :sierra
    sha256 "00b6e0f29dd60d0d67c68b85c3347bc273ff8797871344180ab67ca745ea9fc0" => :el_capitan
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
