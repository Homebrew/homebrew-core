class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.2.src.tar.xz"
  sha256 "3c87fa4ae6d69e1a75477f85451b6f16480418a0018d59e1586a2e3e8954ec47"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f364c8f2cdc0d246b91d7cc877b13affc7f245c9020274ff20bb84e73e39042a"
    sha256 cellar: :any,                 arm64_monterey: "368a74a9ba1c4ab21c0ed1f746870455699db9947a5374e7ccc965f074ac334e"
    sha256 cellar: :any,                 ventura:        "c2c52095cbc6c4226cd2563a0b542142de466c74e9b70f2dbb7487c9f49ca3e0"
    sha256 cellar: :any,                 monterey:       "c11d4e20d8e8d83263bd870f0f4e6298c17b45e2cf12d1e07b6c92e37b1a49fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f99d6e20f70fcf51740998fcbe0709bd1b010990aa28ccdd964e712a9149fb56"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
