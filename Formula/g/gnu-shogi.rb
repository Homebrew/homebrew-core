class GnuShogi < Formula
  desc "Japanese Chess"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftpmirror.gnu.org/gnu/gnushogi/gnushogi-1.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnushogi/gnushogi-1.4.2.tar.gz"
  sha256 "1ecc48a866303c63652552b325d685e7ef5e9893244080291a61d96505d52b29"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e07a2b34459c996910fb2cd8ad3302d978081ab6878330612895115f4b4dd2c2"
    sha256                               arm64_sequoia:  "af1b6d676a20358883f12095fc36af7379e69c8438cc1c3096116b0748952485"
    sha256                               arm64_sonoma:   "0702ff59b956256f5452b9581f38659d15820e201f91fa571eb97f814118fea1"
    sha256                               arm64_ventura:  "f9146b1d94cf4b8376d8c71330f3aea6cad33ebf9af54f9d2e423750ac0b688f"
    sha256                               arm64_monterey: "00b93fd4eaba3beab5e1824a8a6bf62b446f8767ca26c80c3c2ed5f12ac6e3d9"
    sha256                               arm64_big_sur:  "106fee874d8adf30ee887dcf7aa6149cd469c3e629861d105a278a9a66318aea"
    sha256                               sonoma:         "3de4c1a91390acada222f333b503c0fb14d8cbadcefcb468e3fef30adb9a9288"
    sha256                               ventura:        "ef6c5d508b5a76bc305290ee3e644c2823691b168752feab79f3a4ce79379fb8"
    sha256                               monterey:       "c07b78082a29a7db9d4d19fa81f61e7dd89c0f1f184e946e2012fa2fc4bed9d0"
    sha256                               big_sur:        "70258434181a6f40b0c3cddb7e2a5f0119bf953bff5dbd3e795533f558a104ea"
    sha256                               catalina:       "6c559fdfcd24543c1f83f681fe3337048783d17649804b642fb0063dee88d7c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f7b9bcfdffd2c110a5ad05cc370f4fcf322b655152482ed62e35426d61513d0"
    sha256                               x86_64_linux:   "7700579666c89c383d66c691c0deb1531fe3af8b886b1b74ed875803862c5223"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `DRAW'; globals.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", *std_configure_args
    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end

  test do
    (testpath/"test").write <<~EOS
      7g7f
      exit
    EOS

    system bin/"gnushogi < test"
  end
end
