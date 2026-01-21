class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.2.src.tar.xz"
  sha256 "3f988b0923b323d2d25d642f0f749fbfa59194a9fc18c86e224d5caaa2399c5e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "536bd0bebdfe171b1718a62f71a9cbcc9b0902bab358bf092068de7364d1df2b"
    sha256 cellar: :any,                 arm64_sequoia: "36cd242652a84be67c67aa717b759b79bd1faeff1efdaf037e1316d4ed76e25e"
    sha256 cellar: :any,                 arm64_sonoma:  "a869c607c6a9d2deed89898cf141c6b9acf2032beb6604a3f4bb856826d55dfe"
    sha256 cellar: :any,                 sonoma:        "c8e6725f93f9e357fdb18a7d11690c0ffcff94cb139bb5aacad70ac470d82a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3589bd379b3a383937a8c6a4adcb567c116474d6d3200e050082179f985a0b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292bca266bc8e2287c1b906a59180ac09d971fc0e9a141f9d42abe346a43cd8a"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Work around header include order causing issues with `#ifndef isfinite`
    ENV.append "CXXFLAGS", "-include cmath" if DevelopmentTools.clang_build_version >= 1700

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end
