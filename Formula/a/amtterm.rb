class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://gitlab.com/kraxel/amtterm/-/archive/amtterm-1.8-1/amtterm-amtterm-1.8-1.tar.bz2"
  sha256 "d2da2effaa4e8d499a81c9185a3ccde48abffcafaac0d991218dd8974d055719"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/kraxel/amtterm.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "42f7db6addd888cbe1fd7d24597592424c2ee226f4681fd99ba362876165c41e"
    sha256 cellar: :any, arm64_sequoia: "df3c4f069ff8f7d9534f2bdfeb892fcc11d549b8dce700b4f079cb439ec41123"
    sha256 cellar: :any, arm64_sonoma:  "f95f090985c2d0ca7dfb26de8e0aa0b02b1c61173847a4e99b34f061869811b8"
    sha256 cellar: :any, sonoma:        "105ff0233f78b177721306428db8bd052984c5a78a919b3c46c58e4a6b6ee133"
    sha256               arm64_linux:   "0f0b74aea45b53d9b251bac798f8aa2699f42e3202527f21640d1e72a708980a"
    sha256               x86_64_linux:  "154840975aafddd9adc085ed90130611905e52d1cad8a4aa2c3bc4785a21466e"
  end

  depends_on "glib"
  depends_on "gnutls"
  depends_on "meson"
  depends_on "pkgconf"

  on_linux do
    depends_on "gtk+3"
    depends_on "pango"
    depends_on "vte3"
  end

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz"
    sha256 "e359106bab1a45a16044a4c2f8049fad034e5ded1517990bc9b5f8d86dddd301"

    livecheck do
      url :url
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}/amtterm -u brew -p brew 127.0.0.1 2>&1", 1)

    assert_match version.major_minor.to_s, shell_output("#{bin}/amtterm -v 2>&1", 1)
  end
end
