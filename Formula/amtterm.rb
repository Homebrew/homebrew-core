class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://www.kraxel.org/releases/amtterm/amtterm-1.6.tar.gz"
  sha256 "1242cea467827aa1e2e91b41846229ca0a5b3f3e09260b0df9d78dc875075590"
  head "https://www.kraxel.org/cgit/amtterm", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "21db28f850cc553e66e71cf419cf7a975e18e73b6185b3fc1a1f244944d21706" => :catalina
    sha256 "f8ed67be384a24abd8114f058092b923e101a2991f32f712d437c6a292b40a12" => :mojave
    sha256 "eef6949767ce3e19a88f0eb4b146b1444ea39541ab7a075311a8bf11a327f781" => :high_sierra
    sha256 "256736b4dd1d0b427bdb7ca2f9931cc1c403ffe1e43695920160f4f3ffabfe88" => :sierra
    sha256 "4035d9bcb4f6785255a5ea3df1dcc309dbf69441b69dde15b1936e8522fc8e95" => :el_capitan
    sha256 "387897642ba8bcb6daff01adae021264eaf9deea1f264e210e9592b6bc5cc44a" => :yosemite
  end

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz"
    sha256 "e4dee589ef7d66314b3dc956569b2541e0b917e834974e078c256571b6011efe"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/amtterm", "-h"
  end
end
