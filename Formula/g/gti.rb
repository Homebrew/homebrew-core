class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.8.0.tar.gz"
  sha256 "65339ee1d52dede5e862b30582b2adf8aff2113cd6b5ece91775e1510b24ffb9"
  license "MIT"
  head "https://github.com/rwos/gti.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97349fc9a6650a617c1bd2648c700f53cac6f69e41c5a15f99417532fa66e41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82db99490ed0414cb2a724301b9e6c5d4a945281bad8fa050a255461ebe6b00c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e5543b011f73b404717004dcf5280f3e4ad340c2afebd579f245137c0020def"
    sha256 cellar: :any_skip_relocation, ventura:        "78e2007286d0f13fd0a1b236b7453e998ecaa2c9df6e3867446d924c93715109"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb9b0845661d70831ee78f420d9bb3a335471b8c06ad0cf7e040edb44ee6675"
    sha256 cellar: :any_skip_relocation, big_sur:        "86d084489a7fc049de77b93878c57eaab3086ce7603e4aeee9a6552c80a82bcc"
    sha256 cellar: :any_skip_relocation, catalina:       "956beea82bb0bdd277fbdffc71d9eb30115203ca7d868e11c2aec0555af666c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894c5ac7d0251ed9d2bd13da1955c32101484af519de1d042069eb998bdf16e8"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
