class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.0.src.tar.xz"
  sha256 "25ffaf0ee906904e6af784f33ed1ad8ad55280e40bc9dac07a487833ebd124d0"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "311b81b9f06fe3bbea5ffb68a3550d9df70b168abd20f1a2feae8503b6981990"
    sha256 cellar: :any,                 arm64_monterey: "d2cb80a0cc58947c622fb9110ffcd7f64bc6d5c34d8ba82c6608a97f34d9a88e"
    sha256 cellar: :any,                 arm64_big_sur:  "ae0a7658053ae969f8243b6106815f4fc69cca10e0d2afbf6884277b738a031b"
    sha256 cellar: :any,                 ventura:        "ed672f0ce7655c560a46705de6e13cb6e2450f488ee1da73babd079149ffa0a1"
    sha256 cellar: :any,                 monterey:       "09257b93ca1026ddca29643825ee454a64cb2f092f93b77daf0f77f1ba22227d"
    sha256 cellar: :any,                 big_sur:        "5f2488d41a8be9788c1029626116d5f3f531e9fc7bf02b2706a757269185568c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aeffb768702e6a0c92bd7e51cd95fe190cda6060c78967b66f95874b1db6a7e"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end
