class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.2.src.tar.xz"
  sha256 "3c87fa4ae6d69e1a75477f85451b6f16480418a0018d59e1586a2e3e8954ec47"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4457c9bc3b18c8bebd031d42c8fc95a192d173b74aa7391cd921cd2334059b8"
    sha256 cellar: :any,                 arm64_monterey: "fa4dd7d98e359957e51293648f8b2ec4702226176321dc2c2f5708d23fafa859"
    sha256 cellar: :any,                 ventura:        "d9c6a54082c9f940b7b6ca4b197c5531a1d739ce4044a85df62455c55627ddd1"
    sha256 cellar: :any,                 monterey:       "6df3fb9304701688ae61c7431b5fa0586d249c731057a8b01064982ba8b0a31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4b91f7323f7289b29fbdcd15f29a6efe7f4a0109122c9668fe6b946992813a"
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
