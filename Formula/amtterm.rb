class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://www.kraxel.org/releases/amtterm/amtterm-1.6.tar.gz"
  sha256 "1242cea467827aa1e2e91b41846229ca0a5b3f3e09260b0df9d78dc875075590"
  license "GPL-2.0"
  head "https://git.kraxel.org/git/amtterm/", branch: "master", using: :git

  livecheck do
    url "https://www.kraxel.org/releases/amtterm/"
    regex(/href=.*?amtterm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a59e80adf7dd88384f4020c67177de6876f431769b7bd3274759b29bda7204b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7130d5cc879edc7425791e096234f76891e742ebcfcc5c9a7043ebad0fbf8afd"
    sha256 cellar: :any_skip_relocation, monterey:       "c4380ecc8551ea99925203823a63706e8ecdd23b010459528b7a3efc8acb8169"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de2c8131b610bcf1d4d9cf1bb537d2a66b19dbc49e76f26e0ca280e48c1827c"
    sha256 cellar: :any_skip_relocation, catalina:       "ed7067b9e98f43c6a13bd5dc43b5467508e33f209399b4e276da21091ae74907"
    sha256 cellar: :any_skip_relocation, mojave:         "aab6ab711f9b407ef0df77a386b005cc8d10f7c0fb3c9c581659fea65e0edd00"
    sha256 cellar: :any_skip_relocation, high_sierra:    "29180333af292e440f077a00a958ceb6f0035bcee9945233bc33177d0b3549f2"
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
    bin.env_script_all_files(libexec+"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/amtterm", "-h"
  end
end
