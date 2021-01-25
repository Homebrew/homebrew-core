class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.17.tar.gz"
  sha256 "3af4af111536e4e690042bc80834392f46a7e55c7143332d229ff2eb32321e89"
  license "Apache-2.0"
  revision 1
  head "https://github.com/datacharmer/mysql-sandbox.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "effaa2803c9302f19a2ed000d7fc6e07a718186102877822338a90c850b0ba69" => :big_sur
    sha256 "7534bbd546393a62cfd0b6bf5022973094743219dee948d004e790b162152edb" => :arm64_big_sur
    sha256 "0b01929ca2d5a53f9ea2c18dfcef7f4468b5d625ba75dcfcafe5f74ab8954bf6" => :catalina
    sha256 "dc52de83d9b8f7d85273c64665a80165a8d13e8e4654a0655017d3453fac97ed" => :mojave
  end

  uses_from_macos "perl"

  def install
    ENV["PERL_LIBDIR"] = lib/"perl5"
    ENV.prepend_create_path "PERL5LIB", lib/"perl5"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "test", "install"

    Pathname.glob("#{bin}/*") do |file|
      next if file.extname == ".sh"

      libexec.install(file)
      file.write_env_script(libexec.join(file.basename), PERL5LIB: ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
