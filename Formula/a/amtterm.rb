class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://www.kraxel.org/releases/amtterm/amtterm-1.7.tar.gz"
  sha256 "8c58b76b3237504d751bf3588fef25117248a0569523f0d86deaf696d14294d4"
  license "GPL-2.0-or-later"
  head "https://github.com/kraxel/amtterm.git", branch: "master"

  livecheck do
    url "https://www.kraxel.org/releases/amtterm/"
    regex(/href=.*?amtterm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "33934a9d2469315d7e292462ed352c552a01ef9717c98ed502b693fc496731f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "18584332d73c1ec0c92903282b8363ec3d459b2bfacd19748f69607652cc40c8"
  end

  depends_on "gtk+3"
  depends_on :linux
  depends_on "vte3"

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz"
    sha256 "e359106bab1a45a16044a4c2f8049fad034e5ded1517990bc9b5f8d86dddd301"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    # @echo -e accidentally prepends "-e" to the beginning of Make.config
    # which causes the build to fail with an "empty variable" error.
    inreplace "mk/Autoconf.mk", "@echo -e", "@echo"

    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}/amtterm 127.0.0.1 -u brew -p brew 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/amtterm -v 2>&1", 1)
  end
end
