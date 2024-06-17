class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.6.0.src.tar.xz"
  sha256 "c45d076c2113c8a082a9d5775a428b690bb7d972ae2cd22a88d13cda9e9ffaee"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0291ca9069319fdcd819687793de9c47ebb48c599a98f262d22e717dede9ba5d"
    sha256 cellar: :any,                 arm64_monterey: "7909aab7b61f194b11d5c36fef628e20cc7d7bacd5128405b158df4e8df6844b"
    sha256 cellar: :any,                 ventura:        "05db65c0715db978f1178a39c1bd1d6d505fdaaabfe52c8ea762276c5059017a"
    sha256 cellar: :any,                 monterey:       "e4c90391837952b98fc5b321f69d9142690db01229994f899fb757014f51f2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d675f55a42cc46e79b367c17e7e8e6f564ab56f664ad06d3a9eac9a0b30236"
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
