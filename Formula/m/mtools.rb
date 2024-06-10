class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.44.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.44.tar.gz"
  sha256 "10be76148870f984fa44df297473a4e45184472cdb19a4d05ef17fdb59b5d5a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9689a807460b4a4b69876a8b4369f63b98f8b5c6e6cc205923b3636cda22ac52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a0f9a0019cff8eeccd637877d2166969ce9484756debe8a4d93ef8ee1f96380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8390f3de81dde1bc03f9a5bfb5c5f7c84dde0f072e503b991f26f39fcf9ccbbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "420075f755b412d1d8ab8973dbc7a1a9c5ab89f8060f7485c4f65d7579cf665b"
    sha256 cellar: :any_skip_relocation, ventura:        "47aff66ced453f92d383c74546b18bb773dce5ce121603efec5d4dabd2905a86"
    sha256 cellar: :any_skip_relocation, monterey:       "49b0b135fa91f67e246d2c78ec6f159a54ce29b9479f9ec7481a5521a2454404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f33a77cf8b89771cbc7393042ca761fa3db365f9c551496178cea955c12d78"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
