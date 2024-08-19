class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.14.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/clzip/clzip-1.14.tar.gz"
  sha256 "f63fe1245b832fe07ff679e9b9b8687e9379ab613a26bfb0aca3754c8b162d73"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/clzip/"
    regex(/href=.*?clzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9744ed7fe88f28d0566511d46bb9b882216c0c38d0a43b7dacb8640adf2b7ec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a60e73764e4b9e0baa0397319cca7efae34975e443f28f91d4302592485aa04d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6879494e96d4479321c02a397728f038b545dfaf7b55233c373e377bf79f70"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f96e349cd33b83f0a919f124468c98c6edff253070854c7d7ad636800c71a97"
    sha256 cellar: :any_skip_relocation, ventura:        "7e827ac3e9a1af8641959f23d5ca9e2f08aa10ee3100df39cd2b41bc3ed13e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "547c5212a1f2aa403bac98a074e4eded599c94ea4c8d571471daec77914a38af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a464cac0f82326baa343a47b8c66c75d935548e13adcdd30edcaafcb08a2861"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
